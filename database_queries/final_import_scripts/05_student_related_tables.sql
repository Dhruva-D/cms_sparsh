-- =====================================================
-- STEP 05: POPULATE MISSING STUDENT-RELATED TABLES
-- Run AFTER all student data has been imported
-- Creates: Parent, UserLogin, StudentCourse records
-- =====================================================

-- NOTE: This script assumes:
-- 1. Students are already in Acadix_studentregistration
-- 2. FeeStructureMaster may not exist yet (fee_group will be NULL for now)

BEGIN;

-- =====================================================
-- 1. CREATE PARENT RECORDS FOR ALL STUDENTS
-- =====================================================
-- Parent table links to student and has a unique parent_id

INSERT INTO "Acadix_parent" (parent_id, student_id, is_active)
SELECT 
    ROW_NUMBER() OVER (ORDER BY s.id) + 100 as parent_id,
    s.id as student_id,
    true as is_active
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_parent");

-- =====================================================
-- 2. CREATE USERLOGIN RECORDS FOR ALL STUDENTS
-- Username: first_name + registration_no (or admission_no)
-- Password: first_name (plain text stored, should be hashed in production)
-- UserType: 2 = Student
-- =====================================================

-- Ensure UserType 2 exists (Student type)
INSERT INTO "Acadix_usertype" (id, user_type, is_active, created_at, updated_at)
VALUES (2, 'STUDENT', true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Create user logins for students who don't have one yet
INSERT INTO "Acadix_userlogin" (
    user_name, password, plain_password, reference_id, 
    user_type_id, organization_id, branch_id, 
    is_active, is_staff, date_joined, last_login
)
SELECT 
    COALESCE(s.user_name, CONCAT(LOWER(s.first_name), s.registration_no)) as user_name,
    -- Password field (Django will hash it, but for direct SQL insert we store plain)
    s.first_name as password,
    s.first_name as plain_password,
    s.id as reference_id,
    2 as user_type_id,  -- 2 = Student
    s.organization_id,
    s.branch_id,
    true as is_active,
    false as is_staff,
    NOW() as date_joined,
    NULL as last_login
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (
    SELECT reference_id FROM "Acadix_userlogin" WHERE user_type_id = 2
);

-- =====================================================
-- 3. CREATE STUDENTCOURSE RECORDS
-- Links students to their courses for academic tracking
-- NOTE: fee_group and fee_applied_from are NULL until fee structure is set up
-- =====================================================

INSERT INTO "Acadix_studentcourse" (
    academic_year_id, student_id, organization_id, branch_id, 
    batch_id, course_id, department_id, semester_id, section_id,
    fee_group_id, fee_applied_from_id,
    enrollment_no, house_id, 
    hostel_availed, transport_availed, 
    student_status, is_active, is_promoted,
    created_by, updated_by, created_at, updated_at
)
SELECT 
    s.academic_year_id,
    s.id as student_id,
    s.organization_id,
    s.branch_id,
    s.batch_id,
    s.course_id,
    s.department_id,
    s.semester_id,
    s.section_id,
    NULL as fee_group_id,  -- To be set when fee structure is configured
    NULL as fee_applied_from_id,  -- To be set when fee structure is configured
    s.enrollment_no,
    s.house_id,
    false as hostel_availed,
    false as transport_availed,
    'ACTIVE' as student_status,
    true as is_active,
    false as is_promoted,
    s.created_by,
    s.created_by as updated_by,
    NOW() as created_at,
    NOW() as updated_at
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_studentcourse");

COMMIT;

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check counts
SELECT 'Students' as entity, COUNT(*) as count FROM "Acadix_studentregistration"
UNION ALL
SELECT 'Parent Records', COUNT(*) FROM "Acadix_parent"
UNION ALL
SELECT 'UserLogin (Students)', COUNT(*) FROM "Acadix_userlogin" WHERE user_type_id = 2
UNION ALL
SELECT 'StudentCourse', COUNT(*) FROM "Acadix_studentcourse"
ORDER BY entity;

-- Verify all students have related records
SELECT 
    'Students without Parent' as check_name,
    COUNT(*) as missing_count
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_parent")
UNION ALL
SELECT 
    'Students without UserLogin',
    COUNT(*)
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT reference_id FROM "Acadix_userlogin" WHERE user_type_id = 2)
UNION ALL
SELECT 
    'Students without StudentCourse',
    COUNT(*)
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_studentcourse");
