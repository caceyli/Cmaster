WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR EXIT SQL.SQLCODE;

-----------------------------------------------------------------------
----- Create tmp tables -----
------------------------------------------------------------------------

CREATE TABLE TMPALLPDBS (id number(30),element_ID NUMBER(30),VALUE VARCHAR2(80));
CREATE TABLE TMPALLDBS (id number(30),element_ID NUMBER(30),VALUE VARCHAR2(80));

-----------------------------------------------------------------------
----- Create PROCEDURE GET_ALLPDBS-----
-----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE GET_ALLPDBS IS
Begin
Declare cursor refreshedcs is select table_name from user_tables WHERE TABLE_NAME like '%LS100%_IND_CONTAINMENT';
csNumber number (30);
containmentName varchar (30);
baseName varchar (30);
atrrDataName varchar (30);
pdbCount number (30);
childNumber number (30);
childTbName varchar (30);
parentTbName varchar (30);
goodDbId number (30);
badPdbId number (30);
dbName varchar (30);
pdbName varchar (30);

begin
open refreshedcs;
LOOP
    fetch refreshedcs into containmentName;
    exit when refreshedcs%notfound;
    
    select  REGEXP_REPLACE(containmentName, '[^[:digit:]]', '')  into csNumber from dual;

    containmentName:='LS'||csNumber||'_IND_CONTAINMENT';
    baseName:='LS'||csNumber||'_BASE';
    atrrDataName:='LS'||csNumber||'_ATTR_DATA';

    dbms_output.put_line(containmentName);
    dbms_output.put_line(baseName);
    dbms_output.put_line(atrrDataName);
        
    execute immediate 'select count(*) from  '||atrrDataName||' where attribute_name like '''||'lmsDBName'||''' AND CHAR_VALUE LIKE ''%~%''' into pdbCount;
    if pdbCount=0 then
       dbms_output.put_line('That is no PDB.');      
    ELSE
       execute immediate 'CREATE OR REPLACE VIEW CTMP_DB_V as SELECT Min(element_id) as element_id, char_value FROM '||atrrDataName||' where attribute_name like '''||'lmsDBName'||''' AND CHAR_VALUE NOT LIKE ''%~%'' group by CHAR_VALUE';
       execute immediate 'CREATE OR REPLACE VIEW CTMP_PDB_V as SELECT Min(element_id) as element_id, char_value FROM '||atrrDataName||' where attribute_name like '''||'lmsDBName'||''' AND CHAR_VALUE LIKE ''%~%'' group by CHAR_VALUE';
       execute immediate 'insert into TMPALLDBS(element_id,value) SELECT * FROM CTMP_DB_V';
       execute immediate 'update TMPALLDBS set id='||csNumber||' where id is null';
       execute immediate 'insert into TMPALLPDBS(element_id,value) SELECT * FROM CTMP_PDB_V';
       execute immediate 'update TMPALLPDBS set id='||csNumber||' where id is null';
    END IF;
End Loop;

Declare cursor tmpViews is select view_name from user_views where view_name LIKE '%CTMP%_V';
Var01 varchar (80);
Begin
Open tmpViews;
Loop
       fetch tmpViews into Var01;
       exit when tmpViews %notfound;
       dbms_output.put_line('drop view ');
       dbms_output.put_line(Var01);
       execute immediate 'drop view '||Var01||'';
End Loop;
End;

End;
commit;
END;
/

-----------------------------------------------------------------------
----- Create PROCEDURE CHECK_ALLPDBS -----
------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE CHECK_ALLPDBS IS
Id number (30);
dbId number (30);
pdbId number (30);
dbCount number (30);
pdbCount number (30);
pdb varchar (80);
db varchar (80);
subName varchar (80);
preName varchar (80);
csNumber number (30);
containmentName varchar (30);
baseName varchar (30);
atrrDataName varchar (30);

BEGIN
Declare cursor csNumbers is select distinct id from TMPALLPDBS;
begin
open csNumbers;
LOOP
    fetch csNumbers into csNumber;
    exit when csNumbers%notfound;
    
    containmentName:='LS'||csNumber||'_IND_CONTAINMENT';
    baseName:='LS'||csNumber||'_BASE';
    atrrDataName:='LS'||csNumber||'_ATTR_DATA';


   for pdbs in (select id, element_id,value from TMPALLPDBS) loop
       id :=pdbs.id;
       pdbId :=pdbs.element_id;
       pdb :=pdbs.value;
       if id=csNumber then
          select  REGEXP_REPLACE(pdb, '~.*', '')  into preName from dual;
          select  REGEXP_REPLACE(pdb, '.*~', '')  into subName from dual;
          if upper(preName)=upper(subName) then
             dbms_output.put_line(pdb);
             dbms_output.put_line('That is the wrong PDB, needs to be deleted.');
             execute immediate 'select count(*) from TMPALLDBS where id='||csNumber||' and value='''||preName||'''' into dbCount;

             if dbCount=1 then
                 dbms_output.put_line('Deleting the wrong PDB.');
                 execute immediate 'select element_id from TMPALLDBS where id='||csNumber||' and value='''||preName||'''' into dbId;
                 execute immediate 'CREATE OR REPLACE VIEW CTMP_CHILD_V as SELECT CHILD FROM '||containmentName||' where Parent in ('||pdbId||') and child not in (SELECT CHILD FROM '||containmentName||' where Parent in ('||dbId||'))';
                 execute immediate 'delete from '||containmentName||' WHERE PARENT IN (SELECT * FROM CTMP_CHILD_V) OR PARENT IN ('||pdbId||')';
                 execute immediate 'delete from '||containmentName||' WHERE CHILD IN ('||pdbId||')';
                 execute immediate 'delete from '||baseName||' WHERE ID IN (SELECT * FROM CTMP_CHILD_V) OR ID IN ('||pdbId||')';
                 execute immediate 'delete from '||atrrDataName||' WHERE ELEMENT_ID IN (SELECT * FROM CTMP_CHILD_V) OR ELEMENT_ID IN ('||pdbId||')';
                 dbms_output.put_line(dbId);
             end if;          
          else
             dbms_output.put_line('That is the correct PDB.');
          end if;
          dbms_output.put_line(preName);
          dbms_output.put_line(subName);
       end if;
   End Loop;
End Loop;
End;
Declare cursor dropTmpOs is select table_name from user_tables WHERE TABLE_NAME like '%TMPALL%DBS%';
    Var01 varchar (80);
    Begin
    Open dropTmpOs;
    Loop
       fetch dropTmpOs into Var01;
       exit when dropTmpOs %notfound;
       execute immediate 'drop table '||Var01||' ';
    End Loop;
End;
END CHECK_ALLPDBS;
/

EXECUTE GET_ALLPDBS;
EXECUTE CHECK_ALLPDBS;

show errors
COMMIT;
EXIT;
