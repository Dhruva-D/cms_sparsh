# Student Data Import Scripts

## Overview
These SQL scripts are designed for importing student data into a **fresh database**. 
Run them in the specified order.

## Prerequisites
- PostgreSQL database with Django Acadix schema already created
- Organization ID: 1
- Branch ID: 1

## Execution Order

Run the scripts in this exact order:

### Step 0: Schema Modifications
```sql
-- Modifies column sizes and drops unique constraints
\i 00_schema_modifications.sql
```

### Step 1: Lookup Data
```sql
-- Creates: Gender, Religion, Blood Groups, Categories, etc.
\i 01_lookup_data.sql
```

### Step 2: BSC Nursing (2023-2027) - 47 Students
```sql
\i 02a_bsc_2023_2027_structure.sql  -- Creates Batch, Course, Dept, etc.
\i 02b_bsc_2023_2027_students.sql   -- Inserts 47 students
```

### Step 3: GNM Nursing (2025-2028) - 26 Students
```sql
\i 03a_gnm_2025_2028_structure.sql  -- Creates Batch, Course, Dept, etc.
\i 03b_gnm_2025_2028_students.sql   -- Inserts 26 students
```

### Step 4: GNM Nursing (2023-2026) - 28 Students
```sql
\i 04a_gnm_2023_2026_structure.sql  -- Creates Batch, Course, Dept, etc.
\i 04b_gnm_2023_2026_students.sql   -- Inserts 28 students
```

### Step 5: Create Student-Related Records
```sql
\i 05_student_related_tables.sql    -- Creates Parent, UserLogin, StudentCourse
```

This step creates the additional tables that the backend normally creates:
- **Parent**: Links parent_id to student
- **UserLogin**: Creates login credentials (username: first_name + registration_no, password: first_name)
- **StudentCourse**: Links student to course for academic tracking

## Summary

| Batch | Course | Year | Semester | Students |
|-------|--------|------|----------|----------|
| 2023-2027 | Nursing(BSC) | 3rd Year | 5th Semester | 47 |
| 2025-2028 | Nursing(GNM) | 1st Year | 1st Semester | 26 |
| 2023-2026 | Nursing(GNM) | 2nd Year | 1st Semester | 28 |

**Total: 101 students**

## Verification Query

After running all scripts, verify with:

```sql
SELECT 
    b.batch_code,
    c.course_name,
    (SELECT COUNT(*) FROM "Acadix_course" WHERE batch_id = b.id) as courses,
    (SELECT COUNT(*) FROM "Acadix_department" WHERE batch_id = b.id) as departments,
    (SELECT COUNT(*) FROM "Acadix_academicyear" WHERE batch_id = b.id) as academic_years,
    (SELECT COUNT(*) FROM "Acadix_semester" WHERE batch_id = b.id) as semesters,
    (SELECT COUNT(*) FROM "Acadix_section" WHERE batch_id = b.id) as sections,
    COUNT(s.id) as students
FROM "Acadix_studentregistration" s
JOIN "Acadix_batch" b ON s.batch_id = b.id
JOIN "Acadix_course" c ON s.course_id = c.id
GROUP BY b.batch_code, c.course_name, b.id
ORDER BY b.batch_code;
```

Expected result:
- Each batch should have 1 Course, 1 Department, 1 Academic Year, 1 Semester, 1 Section
- Student counts: 28, 47, 26

## Notes

1. Each batch has its own individual:
   - Course (with same code but different batch_id)
   - Department (with same code but different batch_id)
   - Academic Year
   - Semester
   - Section

2. Schema modifications drop unique constraints on:
   - `Acadix_course.course_code`
   - `Acadix_department.department_code`

3. Column size extensions:
   - `registration_no`: varchar(15)
   - `college_admission_no`: varchar(15)
   - `enrollment_no`: varchar(15)
   - `father_contact_number`: varchar(15)
