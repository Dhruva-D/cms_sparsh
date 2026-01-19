-- =====================================================
-- STUDENT REGISTRATION VERIFICATION SCRIPT
-- Checks all tables involved when registering a student
-- from http://localhost:3000/admstudentregistration
-- =====================================================

-- =====================================================
-- SUMMARY: Tables created during Student Registration
-- =====================================================
-- MANDATORY (Always created):
--   1. Acadix_studentregistration - Main student info
--   2. Acadix_studentcourse - Student-Course link with fee group
--   3. Acadix_parent - Parent record
--   4. Acadix_userlogin - Login credentials
--   5. Acadix_studentfeedetail - Fee entries per student
--
-- OPTIONAL (Created if data provided):
--   6. Acadix_address - Address details
--   7. Acadix_siblingdetail - Siblings
--   8. Acadix_studentemergencycontact - Emergency contacts
--   9. Acadix_authorisedpickup - Authorized pickup persons
--  10. Acadix_studentdocument - Documents
--  11. Acadix_studentpreviouseducation - Previous education

-- =====================================================
-- SECTION 1: RECORD COUNTS
-- =====================================================

SELECT 'StudentRegistration' as table_name, COUNT(*) as count FROM "Acadix_studentregistration"
UNION ALL SELECT 'StudentCourse', COUNT(*) FROM "Acadix_studentcourse"
UNION ALL SELECT 'Parent', COUNT(*) FROM "Acadix_parent"
UNION ALL SELECT 'UserLogin (Students)', COUNT(*) FROM "Acadix_userlogin" WHERE user_type_id = 2
UNION ALL SELECT 'StudentFeeDetail', COUNT(*) FROM "Acadix_studentfeedetail"
UNION ALL SELECT 'Address (Students)', COUNT(*) FROM "Acadix_address" WHERE usertype = 'STUDENT'
UNION ALL SELECT 'SiblingDetail', COUNT(*) FROM "Acadix_siblingdetail"
UNION ALL SELECT 'StudentEmergencyContact', COUNT(*) FROM "Acadix_studentemergencycontact"
UNION ALL SELECT 'AuthorisedPickup', COUNT(*) FROM "Acadix_authorisedpickup"
UNION ALL SELECT 'StudentDocument', COUNT(*) FROM "Acadix_studentdocument"
UNION ALL SELECT 'StudentPreviousEducation', COUNT(*) FROM "Acadix_studentpreviouseducation"
ORDER BY table_name;

-- =====================================================
-- SECTION 2: MANDATORY TABLES - MISSING RECORDS CHECK
-- =====================================================

-- Students without StudentCourse record
SELECT 
    'Students WITHOUT StudentCourse' as issue,
    COUNT(*) as missing_count
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_studentcourse");

-- Students without Parent record
SELECT 
    'Students WITHOUT Parent' as issue,
    COUNT(*) as missing_count
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_parent");

-- Students without UserLogin record
SELECT 
    'Students WITHOUT UserLogin' as issue,
    COUNT(*) as missing_count
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT reference_id FROM "Acadix_userlogin" WHERE user_type_id = 2);

-- Students without StudentFeeDetail record
SELECT 
    'Students WITHOUT StudentFeeDetail' as issue,
    COUNT(*) as missing_count
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT DISTINCT student_id FROM "Acadix_studentfeedetail");

-- =====================================================
-- SECTION 3: SUMMARY BY BATCH
-- =====================================================

SELECT 
    b.batch_code,
    c.course_name,
    COUNT(DISTINCT s.id) as total_students,
    COUNT(DISTINCT sc.id) as student_course_count,
    COUNT(DISTINCT p.id) as parent_count,
    COUNT(DISTINCT ul.id) as userlogin_count,
    COUNT(DISTINCT sfd.student_id) as students_with_fees
FROM "Acadix_studentregistration" s
JOIN "Acadix_batch" b ON s.batch_id = b.id
JOIN "Acadix_course" c ON s.course_id = c.id
LEFT JOIN "Acadix_studentcourse" sc ON s.id = sc.student_id
LEFT JOIN "Acadix_parent" p ON s.id = p.student_id
LEFT JOIN "Acadix_userlogin" ul ON s.id = ul.reference_id AND ul.user_type_id = 2
LEFT JOIN "Acadix_studentfeedetail" sfd ON s.id = sfd.student_id
GROUP BY b.batch_code, c.course_name
ORDER BY b.batch_code;

-- =====================================================
-- SECTION 4: SAMPLE DATA CHECK (First 5 students)
-- =====================================================

SELECT 
    s.id as student_id,
    CONCAT(s.first_name, ' ', s.last_name) as student_name,
    s.registration_no,
    b.batch_code,
    CASE WHEN sc.id IS NOT NULL THEN 'Yes' ELSE 'NO' END as has_studentcourse,
    CASE WHEN p.id IS NOT NULL THEN 'Yes' ELSE 'NO' END as has_parent,
    CASE WHEN ul.id IS NOT NULL THEN 'Yes' ELSE 'NO' END as has_userlogin,
    CASE WHEN sfd.student_id IS NOT NULL THEN 'Yes' ELSE 'NO' END as has_feedetail,
    ul.user_name as login_username
FROM "Acadix_studentregistration" s
JOIN "Acadix_batch" b ON s.batch_id = b.id
LEFT JOIN "Acadix_studentcourse" sc ON s.id = sc.student_id
LEFT JOIN "Acadix_parent" p ON s.id = p.student_id
LEFT JOIN "Acadix_userlogin" ul ON s.id = ul.reference_id AND ul.user_type_id = 2
LEFT JOIN (SELECT DISTINCT student_id FROM "Acadix_studentfeedetail") sfd ON s.id = sfd.student_id
ORDER BY s.id
LIMIT 5;

-- =====================================================
-- SECTION 5: FEE STRUCTURE CHECK
-- =====================================================

SELECT 
    fsm.id as fee_structure_id,
    fsm.fee_structure_code,
    fsm.fee_structure_description,
    c.course_name,
    COUNT(DISTINCT fsd.id) as fee_elements,
    COUNT(DISTINCT sfd.student_id) as students_assigned
FROM "Acadix_feestructuremaster" fsm
LEFT JOIN "Acadix_course" c ON fsm.course_id = c.id
LEFT JOIN "Acadix_feestructuredetail" fsd ON fsm.id = fsd.fee_structure_master_id
LEFT JOIN "Acadix_studentfeedetail" sfd ON fsm.id = sfd.fee_group_id
GROUP BY fsm.id, fsm.fee_structure_code, fsm.fee_structure_description, c.course_name
ORDER BY fsm.id;

-- =====================================================
-- SECTION 6: LIST STUDENTS MISSING CRITICAL DATA
-- =====================================================

SELECT 
    s.id,
    s.first_name,
    s.last_name,
    s.registration_no,
    b.batch_code,
    'Missing: ' || 
    CASE WHEN sc.id IS NULL THEN 'StudentCourse, ' ELSE '' END ||
    CASE WHEN p.id IS NULL THEN 'Parent, ' ELSE '' END ||
    CASE WHEN ul.id IS NULL THEN 'UserLogin, ' ELSE '' END ||
    CASE WHEN sfd.student_id IS NULL THEN 'FeeDetail' ELSE '' END as missing_data
FROM "Acadix_studentregistration" s
JOIN "Acadix_batch" b ON s.batch_id = b.id
LEFT JOIN "Acadix_studentcourse" sc ON s.id = sc.student_id
LEFT JOIN "Acadix_parent" p ON s.id = p.student_id
LEFT JOIN "Acadix_userlogin" ul ON s.id = ul.reference_id AND ul.user_type_id = 2
LEFT JOIN (SELECT DISTINCT student_id FROM "Acadix_studentfeedetail") sfd ON s.id = sfd.student_id
WHERE sc.id IS NULL OR p.id IS NULL OR ul.id IS NULL OR sfd.student_id IS NULL
ORDER BY b.batch_code, s.id;
