# Setup Guide — Building and Publishing This Project

This follows the same pattern your instructor used in his own repository
(isolated Pluggable Database + Oracle SQL Developer), adapted for this
Student Information System project. Do each step in order.

## Part 1 — Create an isolated PDB sandbox

**1. Prerequisites**
- Oracle Database 23c Free (or AI edition) already installed on Windows.
- Oracle SQL Developer installed (recommended for running scripts).

**2. Connect as SYSDBA**
Open SQL*Plus and connect:
```sql
sqlplus / as sysdba
```

**3. Check existing PDBs**
```sql
SHOW PDBS;
SHOW CON_NAME;
```

**4. Verify SYSTEM tablespace location**
```sql
SELECT file_name FROM dba_data_files WHERE tablespace_name='SYSTEM';
```

**5. Create the pluggable database**
Replace the path below with the folder your query in step 4 returned.
```sql
CREATE PLUGGABLE DATABASE sis_pdb
    ADMIN USER admin IDENTIFIED BY admin
    FILE_NAME_CONVERT = (
        'C:\APP\<YOUR_WINDOWS_USER>\PRODUCT\23AI\ORADATA\FREE\',
        'C:\APP\<YOUR_WINDOWS_USER>\PRODUCT\23AI\ORADATA\FREE\sis_pdb\'
    );
```

**6. Open and save PDB state**
```sql
ALTER PLUGGABLE DATABASE sis_pdb OPEN;
ALTER PLUGGABLE DATABASE sis_pdb SAVE STATE;
```

**7. Switch session into the new PDB**
```sql
ALTER SESSION SET CONTAINER = sis_pdb;
SHOW CON_NAME;
```

**8. Create the schema owner and grant privileges**
```sql
CREATE USER sis_admin IDENTIFIED BY sis_admin;

GRANT CONNECT, RESOURCE TO sis_admin;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE PROCEDURE, ALTER SESSION TO sis_admin;
GRANT UNLIMITED TABLESPACE TO sis_admin;
```

**9. Verify the PDB**
```sql
SHOW PDBS;
SELECT name FROM v$pdbs;
```
Confirm `SIS_PDB` is listed and `READ WRITE`.

## Part 2 — Run the project scripts

**1. Connect to `sis_pdb` as `sis_admin`** using SQL Developer (recommended)
   or SQL*Plus:
```sql
sqlplus sis_admin/sis_admin@localhost:1521/sis_pdb
```

**2. Run the scripts in order**, taking a screenshot of the output for each
one and saving it into the `screenshots/` folder:

| Script | Purpose |
|---|---|
| `sql/01_create_tables.sql` | Creates all 6 tables with PK/FK constraints |
| `sql/02_insert_data.sql` | Loads sample departments, instructors, students, courses, prerequisites, enrollments |
| `sql/03_cte_examples.sql` | Runs the 5 required CTE examples one block at a time |
| `sql/04_window_functions.sql` | Runs the 4 required window-function categories one block at a time |

**3. Verify the data loaded correctly**
```sql
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM enrollments;
```

**4. Run each query block in `03_cte_examples.sql` and `04_window_functions.sql`
separately** so you can screenshot each result on its own, then paste those
screenshots into the matching section of `README.md`.

## Part 3 — Publish to GitHub (using Git Bash, since that's what you use)

Open **Git Bash** in the `sis-project` folder and run these one at a time.

**1. Initialize the local repository**
```bash
git init
```

**2. Stage all files**
```bash
git add .
```

**3. Make the first commit**
```bash
git commit -m "Initial commit: SIS database, CTEs, and window functions"
```

**4. Create the repository on GitHub**
Go to github.com, click **New repository**, name it using the required
format:
```
database_programming_assignment1_[your_student_id]_[your_firstname]
```
Set visibility to **Public**. Do **not** initialize it with a README (you
already have one) — leave it empty.

**5. Link your local repo to the new GitHub repo**
Replace `<your-username>` and `<repo-name>` with your actual values.
```bash
git remote add origin https://github.com/<your-username>/<repo-name>.git
```

**6. Rename your branch to main (if it isn't already)**
```bash
git branch -M main
```

**7. Push your code**
```bash
git push -u origin main
```

**8. Verify** by refreshing the GitHub page — you should see `README.md`,
`SETUP_GUIDE.md`, the `sql/` folder, and your `screenshots/` and
`er-diagram/` folders.

## Part 4 — Submit

Fill in the Google Form your instructor provided with:
- Full Name
- Student ID
- Group
- GitHub Repository Link
- Business Scenario (1–2 sentences — you can copy the first paragraph of
  Section 1 of the README)
- Key Findings (you can copy Section 6 of the README)
