%let pgm=utl-how-to-store-octave-matlab-objects-in-external-files-for-later-use-with-octave-r-and-python;

%stop_submission;

How to store octave matlab objects in external files for later use with octave r and python

github
https://tinyurl.com/2r9ekpn8
https://github.com/rogerjdeangelis/utl-how-to-store-octave-matlab-objects-in-external-files-for-later-use-with-octave-r-and-python

unlike csv files all these methods support data types (but mostly real and text types)
Aa an added bonus sqlite tables come come bundled with a powerfull sql dialect..

CONTENTS (CREATING COMMON EXPORT AND IMPORT FORMATS FOR OCTAVE)

STORING AND LOADING MAT AND HDF5 WITHIN OCTAVE

  MAT FILES (VERY WORDY ASCII FILES)
  ==================================

  1 save octave dbtable as mat file
    d:/mat/student_data.mat
  2 restart octave and load matfile
    d:/mat/student_data.mat

  HDF5 BINARY FILES
  =================

  3 save octave dbtable as hdf5 file
    d:/h5/mydbtable.h5
  4 restart octave and load hdf5 file

  OCTAVE (SAVE AND LOAD SQLITE TABLES BETWEEN SEPARATE OCTAVE  SESSIONS- FUNCTIONS ON END OF THIS POST))
  ======================================================================

  5 create octave sqlite table want from student_data
  6 load sqlite table table want in a new octave session

  R LOAD OCTAVE SQLITE TABLE INTO R DATAFRAME AND CREATE TABLE FROM_R FOR OCTAVE
  ==============================================================================

  7 load sqlite octave table want into a r dataframe and create new sqlite table 'from_r'
  8 use octave to  read the from_r sqlite table

  PYTHON LOAD OCTAVE SQLITE TABLE WANT INTO PANDA DATAFRAME AND CREATE TABLE FROM_PY FOR OCTAVE
  =============================================================================================

  9 load sqlite octave table want into a panda dataframe and create new sqlite table 'from_py'
 10 use octave to  read the from_py sqlite table

  OCTAVE FUNCTION TO CONVERT OCTAVE TANLES AND DBTABLES TO SQLITE TABLES
  =======================================================================

 11 Octave functions to convert octave tables and dbtables to sqlite tables


SOAPBOX ON

  Objects in octave are often to complex for r or python to read or write.
  You may get away with transporting very simple octave objects with hdf5 and mat files,
  however I think you are better off storing octave data in sqlite tables, which r and python can read.
  Sqlite tables have the add advantage of a powerfull sql dialect.

  The purpose of the repo is to provide a way to save and load octave tables within octave and
  to round trip octave tables with r and python. In other words provide
  a robust way to communicate with any applicatian that can read and write
  sqlite tables. Unfortunately base SAS does not support odbc so base sas canot read or write sqlite tables.

  Below is my understanding of octave, it may not be totally correct.

  Only very simple  octave objects can to read using hdf5 files in r, python.
  List structures tend to very complex.

  I was unable to get r or python to read reasonable octave hdf5 or mat files,
  There is no export format for octave.

  The octave sqlwrite function cannot save an existing octave object into sqlite table.
  Sqlwrite only supports loading strings that contain all the data into sqlite

  This works:

  T = table([1;2],['Name1';'Name2'], 'VariableNames', {'Id','Name'});
  sqlwrite(db, "nut", T, 'ColumnType', {'numeric', 'text'})

  But this does not work:

  Name={"Alice";"Bob";"Charlie";"Diana";"Eve";"Frank"};
  Age=[25;30;22;28;35;40];
  students = dbtable(Name, Age);

  sqlwrite(db, "hardToCrackNut", students, 'ColumnType', {'numeric', 'text'})
  error: Expected sqlquery as a string

  Saving strings with imbeded data is untenable.

  This repository provides functions that save octave objects in sqlite tables.
  This provides for saving and retrieving octave objects not only between
  octave sessions, but also allow R, Python and indirecly excel to
  inteface with octave objects.

  Note is is trivial for octave to fetch sqlite tables, for example.

  want = fetch(db, 'select * from want');
  disp(want)

  The problem is create sqlite tables from octave objects

SOAPBOX OFF

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

%utl_mbegin;
parmcards4;
dbtbl.Name ={"Alice";"Bob";
  "Charlie"};
dbtbl.Age  =[25;30;22];
dbtbl.Score=[88.5;92.0;79.3];
disp(dbtbl)
;;;;
%utl_mend;

/**************************************************************************************************************************/
/* dbtbl (database table)                                                                                                 */
/*                                                                                                                        */
/*    Name =                                                                                                              */
/*    {                                                                                                                   */
/*      [1,1] = Alice                                                                                                     */
/*      [2,1] = Bob                                                                                                       */
/*      [3,1] = Charlie                                                                                                   */
/*    }                                                                                                                   */
/*    Age =                                                                                                               */
/*                                                                                                                        */
/*       25                                                                                                               */
/*       30                                                                                                               */
/*       22                                                                                                               */
/*    Score =                                                                                                             */
/*                                                                                                                        */
/*       88.500                                                                                                           */
/*       92.000                                                                                                           */
/*       79.300                                                                                                           */
/**************************************************************************************************************************/

dbtbl (database table)

   Name =
   {
     [1,1] = Alice
     [2,1] = Bob
     [3,1] = Charlie
   }
   Age =

      25
      30
      22
   Score =

      88.500
      92.000
      79.300


%utl_mbegin;
parmcards4;
dbtbl.Name ={"Alice";"Bob";
  "Charlie"};
dbtbl.Age  =[25;30;22];
dbtbl.Score=[88.5;92.0;79.3];
disp(dbtbl)
;;;;
%utl_mend;

/*                                    _                                    _     __ _ _
/ |  ___  __ ___   _____    ___   ___| |_ __ ___   _____   _ __ ___   __ _| |_  / _(_) | ___
| | / __|/ _` \ \ / / _ \  / _ \ / __| __/ _` \ \ / / _ \ | `_ ` _ \ / _` | __|| |_| | |/ _ \
| | \__ \ (_| |\ V /  __/ | (_) | (__| || (_| |\ V /  __/ | | | | | | (_| | |_ |  _| | |  __/
|_| |___/\__,_| \_/ \___|  \___/ \___|\__\__,_| \_/ \___| |_| |_| |_|\__,_|\__||_| |_|_|\___|

1 SAVE OCTAVE MAT FILE
======================
*/

%utlfkil(d:/mat/student_data.mat);

%utl_mbegin;
parmcards4;
dbtbl.Name ={"Alice";"Bob";
  "Charlie"};
dbtbl.Age  =[25;30;22];
dbtbl.Score=[88.5;92.0;79.3];
disp(dbtbl)
save('d:/mat/student_data.mat','dbtbl');
;;;;
%utl_mend;

/**************************************************************************************************************************/
/*  INPUT DB FILE                     OUTOUT MAT FILE                                                                     */
/*  dbtbl (database table)          # Created by Octave 10.2.0                                                            */
/*                                  # name: dbtbl                                                                         */
/*     Name =                       # type: scalar struct                                                                 */
/*     {                            # ndims: 2                                                                            */
/*       [1,1] = Alice               1 1                                                                                  */
/*       [2,1] = Bob                # length: 3                                                                           */
/*       [3,1] = Charlie            # name: Name                                                                          */
/*     }                            # type: cell                                                                          */
/*     Age =                        # rows: 3                                                                             */
/*                                  # columns: 1                                                                          */
/*        25                        # name: <cell-element>                                                                */
/*        30                        # type: string                                                                        */
/*        22                        # elements: 1                                                                         */
/*     Score =                      # length: 5                                                                           */
/*                                  Alice                                                                                 */
/*        88.500                                                                                                          */
/*        92.000                    # name: <cell-element>                                                                */
/*        79.300                    # type: string                                                                        */
/*                                  # elements: 1                                                                         */
/*                                  # length: 3                                                                           */
/*                                  Bob                                                                                   */
/*                                                                                                                        */
/*                                                                                                                        */
/*                                  # name: <cell-element>                                                                */
/*                                  # type: string                                                                        */
/*                                  # elements: 1                                                                         */
/*                                  # length: 7                                                                           */
/*                                  Charlie                                                                               */
/*                                                                                                                        */
/*                                  # name: Age                                                                           */
/*                                  # type: matrix                                                                        */
/*                                  # rows: 3                                                                             */
/*                                  # columns: 1                                                                          */
/*                                   25                                                                                   */
/*                                   30                                                                                   */
/*                                   22                                                                                   */
/*                                                                                                                        */
/*                                                                                                                        */
/*                                  # name: Score                                                                         */
/*                                  # type: matrix                                                                        */
/*                                  # rows: 3                                                                             */
/*                                  # columns: 1                                                                          */
/*                                   88.5                                                                                 */
/*                                   92                                                                                   */
/*                                   79.299999999999997                                                                   */
/**************************************************************************************************************************/

/*___                  _             _                _                   _                 _                   _    __ _ _
|___ \   _ __ ___  ___| |_ __ _ _ __| |_    ___   ___| |_ __ ___   _____ | | ___   __ _  __| |  _ __ ___   __ _| |_ / _(_) | ___
  __) | | `__/ _ \/ __| __/ _` | `__| __|  / _ \ / __| __/ _` \ \ / / _ \| |/ _ \ / _` |/ _` | | `_ ` _ \ / _` | __| |_| | |/ _ \
 / __/  | | |  __/\__ \ || (_| | |  | |_  | (_) | (__| || (_| |\ V /  __/| | (_) | (_| | (_| | | | | | | | (_| | |_|  _| | |  __/
|_____| |_|  \___||___/\__\__,_|_|   \__|  \___/ \___|\__\__,_| \_/ \___||_|\___/ \__,_|\__,_| |_| |_| |_|\__,_|\__|_| |_|_|\___|

2 RESTART OCTAVE AND LOAD MATFILE
=================================
*/

%utl_mbegin;
parmcards4;
load('d:/mat/student_data.mat');
disp(dbtbl);
;;;;
%utl_mend;

/**************************************************************************************************************************/
/* DBTABLE DBTBL                                                                                                          */
/* Name =                                                                                                                 */
/* {                                                                                                                      */
/*   [1,1] = Alice                                                                                                        */
/*   [2,1] = Bob                                                                                                          */
/*   [3,1] = Charlie                                                                                                      */
/* }                                                                                                                      */
/* Age =                                                                                                                  */
/*                                                                                                                        */
/*    25                                                                                                                  */
/*    30                                                                                                                  */
/*    22                                                                                                                  */
/* Score =                                                                                                                */
/*                                                                                                                        */
/*    88.500                                                                                                              */
/*    92.000                                                                                                              */
/*    79.300                                                                                                              */
/**************************************************************************************************************************/

/*____                       _                    _                   _         _  __ ____     __ _ _
|___ /    ___ _ __ ___  __ _| |_ ___    ___   ___| |_ __ ___   _____ | |__   __| |/ _| ___|   / _(_) | ___
  |_ \   / __| `__/ _ \/ _` | __/ _ \  / _ \ / __| __/ _` \ \ / / _ \| `_ \ / _` | |_|___ \  | |_| | |/ _ \
 ___) | | (__| | |  __/ (_| | ||  __/ | (_) | (__| || (_| |\ V /  __/| | | | (_| |  _|___) | |  _| | |  __/
|____/   \___|_|  \___|\__,_|\__\___|  \___/ \___|\__\__,_| \_/ \___||_| |_|\__,_|_| |____/  |_| |_|_|\___|

3 SAVE OCTAVE TABLE AS HDF5 FILE
================================
*/

%utl_mbegin;
parmcards4;
dbtbl.Name ={"Alice";"Bob";
  "Charlie"};
dbtbl.Age  =[25;30;22];
dbtbl.Score=[88.5;92.0;79.3];
disp(dbtbl)
save('-hdf5','d:/h5/mydbtable.h5','dbtbl');
;;;;
%utl_mend;

/**************************************************************************************************************************/
/* SAMPLE                                                                                                                 */
/* d:/h5/mydbtable.h5 (binary output)                                                                                     */
/*                                                                                                                        */
/*  771  .........ˆ........ˆ.......¨.........P.....# Created by Oct                                                       */
/* ZONE  01010000080010000080000000A0000000005000002247667662672467                                                       */
/* NUMR  0000000008000000008000000082000000D00000003032514540290F34                                                       */
/*                                                                                                                        */
/*  841  ave 10.2.0, Wed Jun 25 07:35:31 2025 UTC <unknown@T7610>..                                                       */
/* ZONE  6762332323225662476233233333333233332554237666676453333300                                                       */
/* NUMR  165010E2E0C07540A5E025007A35A310202505430C5EBEF7E047610E00                                                       */
/*                                                                                                                        */
/*  911  ..................0A......`.......TREE....ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ                                                       */
/* ZONE  001000000010100000340000006000000055440000FFFFFFFFFFFFFFFF                                                       */
/* NUMR  008000000000000000010000000000000042550010FFFFFFFFFFFFFFFF                                                       */
/**************************************************************************************************************************/

/*  _                   _             _     _                 _  _         _  __ ____     __ _ _
| || |    _ __ ___  ___| |_ __ _ _ __| |_  | | ___   __ _  __| || |__   __| |/ _| ___|   / _(_) | ___
| || |_  | `__/ _ \/ __| __/ _` | `__| __| | |/ _ \ / _` |/ _` || `_ \ / _` | |_|___ \  | |_| | |/ _ \
|__   _| | | |  __/\__ \ || (_| | |  | |_  | | (_) | (_| | (_| || | | | (_| |  _|___) | |  _| | |  __/
   |_|   |_|  \___||___/\__\__,_|_|   \__| |_|\___/ \__,_|\__,_||_| |_|\__,_|_| |____/  |_| |_|_|\___|

4 restart load hdf5 file
*/

%utl_mbegin;
parmcards4;
load('-hdf5','d:/h5/mydbtable.h5');
disp(dbtbl)
;;;;
%utl_mend;

/**************************************************************************************************************************/
/* dbtable dbtbl                                                                                                          */
/* Age =                                                                                                                  */
/*                                                                                                                        */
/*    25                                                                                                                  */
/*    30                                                                                                                  */
/*    22                                                                                                                  */
/*                                                                                                                        */
/* Name =                                                                                                                 */
/* {                                                                                                                      */
/*   [1,1] = Alice                                                                                                        */
/*   [2,1] = Bob                                                                                                          */
/*   [3,1] = Charlie                                                                                                      */
/* }                                                                                                                      */
/*                                                                                                                        */
/* Score =                                                                                                                */
/*                                                                                                                        */
/*    88.500                                                                                                              */
/*    92.000                                                                                                              */
/*    79.300                                                                                                              */
/**************************************************************************************************************************/

/*___                        _                    _                             _ _ _         _        _     _
| ___|    ___ _ __ ___  __ _| |_ ___    ___   ___| |_ __ ___   _____  ___  __ _| (_) |_ ___  | |_ __ _| |__ | | ___
|___ \   / __| `__/ _ \/ _` | __/ _ \  / _ \ / __| __/ _` \ \ / / _ \/ __|/ _` | | | __/ _ \ | __/ _` | `_ \| |/ _ \
 ___) | | (__| | |  __/ (_| | ||  __/ | (_) | (__| || (_| |\ V /  __/\__ \ (_| | | | ||  __/ | || (_| | |_) | |  __/
|____/   \___|_|  \___|\__,_|\__\___|  \___/ \___|\__\__,_| \_/ \___||___/\__, |_|_|\__\___|  \__\__,_|_.__/|_|\___|
                                                                             |_|
5 CREATE OCTAVE SQLITE TABLE WANT FROM STUDENT_DATA
===================================================
*/


/*---- delete the entire sqlite database ----*/
%utlfkil(d:/sqlite/have.db);

%utl_mbegin;
parmcards4;

pkg load dataframe
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
pkg load statistics

db = sqlite("d:/sqlite/have.db","create");
execute(db, 'select load_extension("d:/dll/sqlean")');

Name={"Alice";"Bob";"Charlie";"Diana";"Eve";"Frank"};
Age=[25;30;22;28;35;40];
Score=[88.5;92.0;79.5;85.0;91.5;87.0];
students=dbtable(Name,Age,Score);
disp(students)

##################################################
##  local dbtable students                      ##
##  6x3 table                                   ##
##                                              ##
##  Name     Age  Score                         ##
##  _______  ___  _____                         ##
##                                              ##
##  Alice    25   88.5                          ##
##  Bob      30   92                            ##
##  Charlie  22   79.5                          ##
##  Diana    28   85                            ##
##  Eve      35   91.5                          ##
##  Frank    40   87                            ##
##################################################

execute(db,"drop table if exists _temp_");
execute(db,"drop table if exists stats");

sql_create_insert(db,students,"want")

meta = fetch(db, "PRAGMA table_info('want');");
disp(meta);

want = fetch(db, 'select * from want');
disp(want)

##################################################
##  sqlite table want                           ##
##                                              ##
##   cid  name   type  notnull  dflt_value  pk  ##
##   ___  _____  ____  _______  __________  __  ##
##                                              ##
##   0    Name   TEXT  0                    0   ##
##   1    Age    REAL  0                    0   ##
##   2    Score  REAL  0                    0   ##
##                                              ##
##  Name     Age  Score                         ##
##  _______  ___  _____                         ##
##                                              ##
##  Alice    25   88.5                          ##
##  Bob      30   92                            ##
##  Charlie  22   79.5                          ##
##  Diana    28   85                            ##
##  Eve      35   91.5                          ##
##  Frank    40   87                            ##
##################################################
close(db);
;;;;
%utl_mend;

/*__     _                 _             _ _ _       _        _     _       _                                                 _
 / /_   | | ___   __ _  __| |  ___  __ _| (_) |_ ___| |_ __ _| |__ | | ___ (_)_ __    _ __   _____      __  ___  ___  ___ ___(_) ___  _ __
| `_ \  | |/ _ \ / _` |/ _` | / __|/ _` | | | __/ _ \ __/ _` | `_ \| |/ _ \| | `_ \  | `_ \ / _ \ \ /\ / / / __|/ _ \/ __/ __| |/ _ \| `_ \
| (_) | | | (_) | (_| | (_| | \__ \ (_| | | | ||  __/ || (_| | |_) | |  __/| | | | | | | | |  __/\ V  V /  \__ \  __/\__ \__ \ | (_) | | | |
 \___/  |_|\___/ \__,_|\__,_| |___/\__, |_|_|\__\___|\__\__,_|_.__/|_|\___||_|_| |_| |_| |_|\___| \_/\_/   |___/\___||___/___/_|\___/|_| |_|
                                      |_|
6 LOAD SQLITE TABLE TABLE WANT IN A NEW OCTAVE SESSION
======================================================
*/

%utl_mbegin;
parmcards4;
pkg load sqlite
db = sqlite("d:/sqlite/have.db");
execute(db, 'select load_extension("d:/dll/sqlean")');
want = fetch(db, 'select * from want');
disp(want)
close(db);
;;;;
%utl_mend;

/**************************************************************************************************************************/
/* DBTABLE DBTBL                                                                                                          */
/* 6x3 table                                                                                                              */
/*                                                                                                                        */
/* Name     Age  Score                                                                                                    */
/* _______  ___  _____                                                                                                    */
/*                                                                                                                        */
/* Alice    25   88.5                                                                                                     */
/* Bob      30   92                                                                                                       */
/* Charlie  22   79.5                                                                                                     */
/* Diana    28   85                                                                                                       */
/* Eve      35   91.5                                                                                                     */
/* Frank    40   87                                                                                                       */
/**************************************************************************************************************************/

/*____             _ _ _      __            _       _         __                         __             _ _ _
|___  |  ___  __ _| (_) |_ ___\ \ _ __   __| | __ _| |_ __ _ / _|_ __ __ _ _ __ ___   ___\ \  ___  __ _| (_) |_ ___
   / /  / __|/ _` | | | __/ _ \\ \ `__| / _` |/ _` | __/ _` | |_| `__/ _` | `_ ` _ \ / _ \\ \/ __|/ _` | | | __/ _ \
  / /   \__ \ (_| | | | ||  __// / |   | (_| | (_| | || (_| |  _| | | (_| | | | | | |  __// /\__ \ (_| | | | ||  __/
 /_/    |___/\__, |_|_|\__\___/_/|_|    \__,_|\__,_|\__\__,_|_| |_|  \__,_|_| |_| |_|\___/_/ |___/\__, |_|_|\__\___|
                |_|                                                                                  |_|
7 LOAD SQLITE OCTAVE TABLE WANT INTO A R DATAFRAME AND CREATE NEW SQLITE TABLE 'FROM_R'
======================================================================================
*/

libname sd1 "d:/sd1";
proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(DBI)
library(RSQLite)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
con <- dbConnect(RSQLite::SQLite(), "d:/sqlite/have.db")
dbGetQuery(con, "PRAGMA table_info('want')")
print(dbListTables(con))
want <- dbReadTable(con, "want")
print(head(want))
dbWriteTable(con, name = "from_r", value = want, overwrite = TRUE)
dbGetQuery(con, "PRAGMA table_info('from_r')")
dbDisconnect(con)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* INPUT WANT SQLITE TABLE                                                                                                */
/*                                                                                                                        */
/* > dbGetQuery(con, "PRAGMA table_info('want')")                                                                         */
/*   cid  name type notnull dflt_value pk                                                                                 */
/* 1   0  Name TEXT       0         NA  0                                                                                 */
/* 2   1   Age REAL       0         NA  0                                                                                 */
/* 3   2 Score REAL       0         NA  0                                                                                 */
/*                                                                                                                        */
/* CONVERT FROM_R DATAFRAME                                                                                               */
/* > print(head(want))                                                                                                    */
/*      Name Age Score                                                                                                    */
/* 1   Alice  25  88.5                                                                                                    */
/* 2     Bob  30  92.0                                                                                                    */
/* 3 Charlie  22  79.5                                                                                                    */
/* 4   Diana  28  85.0                                                                                                    */
/* 5     Eve  35  91.5                                                                                                    */
/* 6   Frank  40  87.0                                                                                                    */
/*                                                                                                                        */
/* FROM_PY R DATAFRAME IN A SQLITE TABLE                                                                                  */
/* > dbGetQuery(con, "PRAGMA table_info('from_r')")                                                                       */
/*   cid  name type notnull dflt_value pk                                                                                 */
/* 1   0  Name TEXT       0         NA  0                                                                                 */
/* 2   1   Age REAL       0         NA  0                                                                                 */
/* 3   2 Score REAL       0         NA  0                                                                                 */
/*                                                                                                                        */
/* SAS DATASET WANT                                                                                                       */
/*                                                                                                                        */
/* NAME       AGE    SCORE                                                                                                */
/*                                                                                                                        */
/* Alice       25     88.5                                                                                                */
/* Bob         30     92.0                                                                                                */
/* Charlie     22     79.5                                                                                                */
/* Diana        28     85.0                                                                                                 */
/* Eve         35     91.5                                                                                                */
/* Frank       40     87.0                                                                                                */
/**************************************************************************************************************************/

/*___              _                                       _  _   _             __                             _        _     _
 ( _ )   ___   ___| |_ __ ___   _____   _ __ ___  __ _  __| || |_| |__   ___   / _|_ __ ___  _ __ ___    _ __ | |_ __ _| |__ | | ___
 / _ \  / _ \ / __| __/ _` \ \ / / _ \ | `__/ _ \/ _` |/ _` || __| `_ \ / _ \ | |_| `__/ _ \| `_ ` _ \  | `__|| __/ _` | `_ \| |/ _ \
| (_) || (_) | (__| || (_| |\ V /  __/ | | |  __/ (_| | (_| || |_| | | |  __/ |  _| | | (_) | | | | | | | |   | || (_| | |_) | |  __/
 \___/  \___/ \___|\__\__,_| \_/ \___| |_|  \___|\__,_|\__,_| \__|_| |_|\___| |_| |_|  \___/|_| |_| |_|_|_|    \__\__,_|_.__/|_|\___|
                                                                                                   |___|
8 use octave to  read the from_r sqlite table
=============================================
*/

%utl_mbegin;
parmcards4;
pkg load sqlite
db = sqlite("d:/sqlite/have.db");
execute(db, 'select load_extension("d:/dll/sqlean")');
want = fetch(db, 'select * from from_r');
meta = fetch(db, "PRAGMA table_info('from_r');");
disp(meta);
disp(want)
close(db);
;;;;
%utl_mend;

 /*************************************************************************************************************************/
 /* READ THIS SQLITE TABLE FROM R                                                                                         */
 /*                                                                                                                       */
 /* FROM_R  SQLITE TABLE                                                                                                  */
 /* 3x6 table                                                                                                             */
 /*                                                                                                                       */
 /* cid  name   type  notnull  dflt_value  pk                                                                             */
 /* ___  _____  ____  _______  __________  __                                                                             */
 /*                                                                                                                       */
 /* 0    Name   TEXT  0                    0                                                                              */
 /* 1    Age    REAL  0                    0                                                                              */
 /* 2    Score  REAL  0                    0                                                                              */
 /* 6x3 table                                                                                                             */
 /*                                                                                                                       */
 /* OCTAVE LOCAL DBTABLE WANT                                                                                             */
 /*                                                                                                                       */
 /* Name     Age  Score                                                                                                   */
 /* _______  ___  _____                                                                                                   */
 /*                                                                                                                       */
 /* Alice    25   88.5                                                                                                    */
 /* Bob      30   92                                                                                                      */
 /* Charlie  22   79.5                                                                                                    */
 /* Diana    28   85                                                                                                      */
 /* Eve      35   91.5                                                                                                    */
 /* Frank    40   87                                                                                                      */
/**************************************************************************************************************************/

/*___              _ _ _      __                   _       _         __                          __             _ _ _
 / _ \   ___  __ _| (_) |_ ___\ \ _ __  _   _   __| | __ _| |_ __ _ / _|_ __ __ _ _ __ ___   ___\ \  ___  __ _| (_) |_ ___
| (_) | / __|/ _` | | | __/ _ \\ \ `_ \| | | | / _` |/ _` | __/ _` | |_| `__/ _` | `_ ` _ \ / _ \\ \/ __|/ _` | | | __/ _ \
 \__, | \__ \ (_| | | | ||  __// / |_) | |_| || (_| | (_| | || (_| |  _| |   | (_| | | | | | |  __// /\__ \ (_| | | | ||  __/
   /_/  |___/\__, |_|_|\__\___/_/| .__/ \__, | \__,_|\__,_|\__\__,_|_| |_|  \__,_|_| |_| |_|\___/_/ |___/\__, |_|_|\__\___|
                |_|              |_|    |___/                                                               |_|
9 LOAD SQLITE OCTAVE TABLE WANT INTO A PANDA DATAFRAME AND CREATE NEW SQL  ITE TABLE 'FROM_PY'
=============================================================================================
*/

%utl_pybeginx;
parmcards4;
import sqlite3
import pandas as pd
exec(open('c:/oto/fn_pythonx.py').read());
con = sqlite3.connect(r'd:/sqlite/have.db')
want = pd.read_sql_query("SELECT * FROM want", con)
print(want.head())
from_py=want;
from_py.to_sql('from_py', con, if_exists='replace', index=False)
con.close()
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/* PYTHON READ THIS OCTAVE TABLE                                                                                          */
/* cid  name   type  notnull  dflt_value  pk                                                                              */
/* ___  _____  ____  _______  __________  __                                                                              */
/*                                                                                                                        */
/* 0    Name   TEXT  0                    0                                                                               */
/* 1    Age    REAL  0                    0                                                                               */
/* 2    Score  REAL  0                    0                                                                               */
/*                                                                                                                        */
/* CREATED A PANDA FROM_PY                                                                                                */
/*                                                                                                                        */
/*        Name   Age  Score                                                                                               */
/*  0    Alice  25.0   88.5                                                                                               */
/*  1      Bob  30.0   92.0                                                                                               */
/*  2  Charlie  22.0   79.5                                                                                               */
/*  3    Diana  28.0   85.0                                                                                               */
/*  4      Eve  35.0   91.5                                                                                               */
/*                                                                                                                        */
/* CREATED SQLITE TABLE FROM_PY FROM PANDA DATAFRAME                                                                      */
/*                                                                                                                        */
/* cid  name   type  notnull  dflt_value  pk                                                                              */
/* ___  _____  ____  _______  __________  __                                                                              */
/*                                                                                                                        */
/* 0    Name   TEXT  0                    0                                                                               */
/* 1    Age    REAL  0                    0                                                                               */
/* 2    Score  REAL  0                    0                                                                               */
/*                                                                                                                        */
/*                                                                                                                        */
/* SAS DATASET WANT                                                                                                       */                     */
/*                                                                                                                        */
/* NAME       AGE    SCORE                                                                                                */                    */
/*                                                                                                                        */
/* Alice       25     88.5                                                                                                */                    */
/* Bob         30     92.0                                                                                                */                       */
/* Charlie     22     79.5                                                                                                */                       */
/* Diana       28     85.0                                                                                                */                       */
/* Eve         35     91.5                                                                                                */                       */
/* Frank       40     87.0                                                                                                */                       */
/**************************************************************************************************************************/

/*  ___    __                                  __             _                   _        _     _
/ |/ _ \  / _|_ __ ___  _ __ ___    _ __  _   _\ \  ___   ___| |_ __ ___   _____ | |_ __ _| |__ | | ___
| | | | || |_| `__/ _ \| `_ ` _ \  | `_ \| | | |\ \/ _ \ / __| __/ _` \ \ / / _ \| __/ _` | `_ \| |/ _ \
| | |_| ||  _| | | (_) | | | | | | | |_) | |_| |/ / (_) | (__| || (_| |\ V /  __/| || (_| | |_) | |  __/
|_|\___/ |_| |_|  \___/|_| |_| |_|_| .__/ \__, /_/ \___/ \___|\__\__,_| \_/ \___| \__\__,_|_.__/|_|\___|
                                |__|_|    |___/
10 USE OCTAVE TO  READ THE FROM_PY SQLITE TABLE
================================================
*/

%utl_mbegin;
parmcards4;
pkg load sqlite
db = sqlite("d:/sqlite/have.db");
execute(db, 'select load_extension("d:/dll/sqlean")');
meta = fetch(db, "PRAGMA table_info('from_py');");
disp('meta');
disp(meta);
dbtbl = fetch(db, 'select * from from_py');
disp('dbtbl')
disp(dbtbl)
close(db);
;;;;
%utl_mend;

/**************************************************************************************************************************/
/* sqllite table from_py                                                                                                  */
/* from_py                                                                                                                */
/*   3x6 table                                                                                                            */
/*                                                                                                                        */
/*   cid  name   type  notnull  dflt_value  pk                                                                            */
/*   ___  _____  ____  _______  __________  __                                                                            */
/*                                                                                                                        */
/*   0    Name   TEXT  0                    0                                                                             */
/*   1    Age    REAL  0                    0                                                                             */
/*   2    Score  REAL  0                    0                                                                             */
/*                                                                                                                        */
/*                                                                                                                        */
/* LOCAL OCTAVE DBTBL  (FROM FROM_PY TABLE                                                                                */
/*  Name     Age  Score                                                                                                   */
/*  _______  ___  _____                                                                                                   */
/*                                                                                                                        */
/*  Alice    25   88.5                                                                                                    */
/*  Bob      30   92                                                                                                      */
/*  Charlie  22   79.5                                                                                                    */
/*  Diana    28   85                                                                                                      */
/*  Eve      35   91.5                                                                                                    */
/*  Frank    40   87                                                                                                      */
/**************************************************************************************************************************/

/* _              _                     __             _   _
/ / |   ___   ___| |_ __ ___   _____   / _|_   _ _ __ | |_(_) ___  _ __  ___
| | |  / _ \ / __| __/ _` \ \ / / _ \ | |_| | | | `_ \| __| |/ _ \| `_ \/ __|
| | | | (_) | (__| || (_| |\ V /  __/ |  _| |_| | | | | |_| | (_) | | | \__ \
|_|_|  \___/ \___|\__\__,_| \_/ \___| |_|  \__,_|_| |_|\__|_|\___/|_| |_|___/

11 OCTAVE FUNCTIONS TO CONVERT OCTAVE TABLES AND DBTABLES TO SQLITE TABLES
===========================================================================
*/

The following filename assignments, copy the functions to the octave autocall folder in windows.
Once in the folder the functions can be call by name.

%let oto=C:/Program Files/GNU Octave/Octave-10.2.0/mingw64/share/octave/10.2.0/m/miscellaneous;

filename ft15f001 "&oto/sql_create_table.m";
parmcards4;
function sql_create_table(db,inp,quoted_table);

  colnames = inp.Properties.VariableNames;
  ncols = numel(colnames);
  sqlcols = cell(1, ncols);

  for i = 1:ncols
    colname = colnames{i};
    coldata = inp.(colname);
    firstval = coldata(1);
    if iscell(firstval) && (ischar(firstval{1,1}) || isstring(firstval{1,1}))
        sqltype = "TEXT";
    else
        sqltype = "REAL";
    end
    sqlcols{i} = sprintf('%s %s', colname, sqltype);
  end

  sql_str = sprintf('( %s )', strjoin(sqlcols, ','));

  sql_make = ["create table ", quoted_table, sql_str];

  disp(sql_make)
  execute(db,sql_make);

end
;;;;
run;quit;

filename ft15f001 "&oto/sql_insert.m";
parmcards4;
function sql_insert(db,inp,out);

   sql_delete = sprintf('DELETE FROM %s;', out);
   execute(db,sql_delete)

   columns = inp.Properties.VariableNames;
   n_rows  = size(inp, 1);

   % Construct and execute INSERT for each row
      for i = 1:n_rows
          % Get values for the current row
          values = cell(1, length(columns));
          for j = 1:length(columns)
              col_data = inp.(columns{j});
              if iscell(col_data)
                  values{j} = col_data{i};   % Handle text fields
              else
                  values{j} = col_data(i);   % Handle numeric fields
              end
          end
          formatted_values = cell(1, length(values));
          for k = 1:length(values)
              if ischar(values{k})
                  % Escape single quotes and wrap in SQL quotes
                  escaped_str = strrep(values{k}, "'", "''");
                  formatted_values{k} = sprintf("'%s'", escaped_str);
              else
                  formatted_values{k} = num2str(values{k});  % Convert numbers to strings
              end
          end

          % Build the INSERT query safely
          col_list = strjoin(columns, ', ');
          val_list = strjoin(formatted_values, ', ');
          query = sprintf('INSERT INTO %s (%s) VALUES (%s)',out, col_list, val_list);
          execute(db, query);
      end
      disp(query);
end
;;;;
run;quit;

filename ft15f001 "&oto/sql_create_insert.m";
parmcards4;
function sql_create_insert(db,dbtbl,sqltbl)

   sql_create_table(db,dbtbl,sqltbl);
   sql_insert      (db,dbtbl,sqltbl);

end;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
