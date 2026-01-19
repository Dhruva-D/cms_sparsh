-- =====================================================
-- ADD PARENT AND USERLOGIN FOR ALL STUDENTS
-- Uses same logic as backend UI registration
-- =====================================================
-- Logic from backend:
-- admission_no: last_admission_no + 1 (starts from 1001)
-- username: first_name + admission_no
-- password: first_name
-- =====================================================

BEGIN;

-- =====================================================
-- STEP 1: UPDATE ADMISSION_NO FOR STUDENTS WHO DON'T HAVE ONE
-- =====================================================

-- First check what we have
SELECT 'Before Update - Admission Numbers' as status;
SELECT 
    COUNT(*) as total_students,
    COUNT(admission_no) as has_admission_no,
    COUNT(*) - COUNT(admission_no) as missing_admission_no,
    MAX(admission_no::int) as max_admission_no
FROM "Acadix_studentregistration"
WHERE admission_no IS NOT NULL AND admission_no != '';

-- Update students who don't have admission_no
DO $$
DECLARE
    last_admission_no INT;
    counter INT := 0;
    student_rec RECORD;
BEGIN
    -- Get the last admission_no, or start from 1000
    SELECT COALESCE(MAX(admission_no::int), 1000) INTO last_admission_no 
    FROM "Acadix_studentregistration" 
    WHERE admission_no IS NOT NULL AND admission_no != '' AND admission_no ~ '^\d+$';
    
    RAISE NOTICE 'Last admission_no found: %', last_admission_no;
    
    -- Loop through students without admission_no
    FOR student_rec IN 
        SELECT id, first_name 
        FROM "Acadix_studentregistration"
        WHERE admission_no IS NULL OR admission_no = ''
        ORDER BY id
    LOOP
        counter := counter + 1;
        UPDATE "Acadix_studentregistration"
        SET admission_no = (last_admission_no + counter)::text
        WHERE id = student_rec.id;
    END LOOP;
    
    RAISE NOTICE 'Updated % students with new admission numbers', counter;
END $$;

-- =====================================================
-- STEP 2: UPDATE USER_NAME FOR STUDENTS WHO DON'T HAVE ONE
-- username = first_name + admission_no
-- =====================================================

UPDATE "Acadix_studentregistration"
SET user_name = LOWER(first_name) || admission_no
WHERE user_name IS NULL OR user_name = '';

-- =====================================================
-- STEP 3: CREATE PARENT RECORDS
-- =====================================================

DO $$
DECLARE
    last_parent_id INT;
    counter INT := 0;
    student_rec RECORD;
BEGIN
    SELECT COALESCE(MAX(parent_id), 100) INTO last_parent_id FROM "Acadix_parent";
    
    FOR student_rec IN 
        SELECT id FROM "Acadix_studentregistration"
        WHERE id NOT IN (SELECT student_id FROM "Acadix_parent")
        ORDER BY id
    LOOP
        counter := counter + 1;
        INSERT INTO "Acadix_parent" (parent_id, student_id, is_active)
        VALUES (last_parent_id + counter, student_rec.id, true);
    END LOOP;
    
    RAISE NOTICE 'Created % parent records', counter;
END $$;

-- =====================================================
-- STEP 4: CREATE USERLOGIN RECORDS
-- username = first_name + admission_no
-- password = first_name
-- =====================================================

-- Ensure UserType 2 (Student) exists
INSERT INTO "Acadix_usertype" (id, user_type, created_by, is_active, created_at, updated_at)
VALUES (2, 'STUDENT', 1, true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Create UserLogin records
INSERT INTO "Acadix_userlogin" (
    user_name, 
    password, 
    plain_password, 
    reference_id, 
    user_type_id, 
    organization_id, 
    branch_id, 
    is_active, 
    is_staff, 
    is_superuser,
    date_joined
)
SELECT 
    s.user_name as user_name,
    s.first_name as password,
    s.first_name as plain_password,
    s.id as reference_id,
    2 as user_type_id,
    s.organization_id,
    s.branch_id,
    true as is_active,
    false as is_staff,
    false as is_superuser,
    NOW() as date_joined
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (
    SELECT reference_id FROM "Acadix_userlogin" WHERE user_type_id = 2
)
AND s.user_name IS NOT NULL
ON CONFLICT (user_name) DO NOTHING;

COMMIT;

-- =====================================================
-- VERIFICATION
-- =====================================================

SELECT '=== VERIFICATION ===' as section;

-- Record counts
SELECT 'StudentRegistration' as table_name, COUNT(*) as count FROM "Acadix_studentregistration"
UNION ALL SELECT 'Parent', COUNT(*) FROM "Acadix_parent"
UNION ALL SELECT 'UserLogin (Students)', COUNT(*) FROM "Acadix_userlogin" WHERE user_type_id = 2
ORDER BY table_name;

-- Check missing records
SELECT 'Students still missing Parent' as check_type, COUNT(*) as count
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT student_id FROM "Acadix_parent")

UNION ALL

SELECT 'Students still missing UserLogin', COUNT(*)
FROM "Acadix_studentregistration" s
WHERE s.id NOT IN (SELECT reference_id FROM "Acadix_userlogin" WHERE user_type_id = 2);

-- Show sample login credentials
SELECT '=== SAMPLE LOGIN CREDENTIALS ===' as section;

SELECT 
    s.first_name || ' ' || COALESCE(s.last_name, '') as student_name,
    b.batch_code,
    s.admission_no,
    ul.user_name as login_username,
    ul.plain_password as login_password
FROM "Acadix_studentregistration" s
JOIN "Acadix_batch" b ON s.batch_id = b.id
LEFT JOIN "Acadix_userlogin" ul ON s.id = ul.reference_id AND ul.user_type_id = 2
ORDER BY b.batch_code, s.id
LIMIT 10;
