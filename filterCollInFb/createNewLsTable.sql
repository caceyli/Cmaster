Declare
allnetlsid number (30);
spesficnetlsid number(30);
containerName varchar(30);
baseName varchar(30);
atrrDataName varchar(30);
localscanexp varchar(30);
exp varchar(30);
containerName0 varchar(30);
baseName0 varchar(30);
atrrDataName0 varchar(30);
localscanexp0 varchar(30);
exp0 varchar(30);
element_count NUMBER;  
parents_table VARCHAR2(256);
children_table VARCHAR2(256);
children_count NUMBER;
use_cas_id_1 NUMBER;
elecount number(30);
datacount number(30);
contacount number(30);

includenets varchar(300);
csname varchar(100);

Begin

Declare cursor dropCtmptb is select table_name from user_tables WHERE TABLE_NAME like '%CTMP_%';
Var01 varchar (80);
Begin
Open dropCtmptb;
Loop
   fetch dropCtmptb into Var01;
   exit when dropCtmptb %notfound;
   execute immediate 'drop table '||Var01||' ';
End Loop;
End;

select max(id) into spesficnetlsid from local_scan;

dbms_output.put_line(spesficnetlsid);

allnetlsid:=&1;
includenets:='''&2''';
csname:='''&3''';
containerName:='LS'||allnetlsid||'_CONTAINER';
baseName:='LS'||allnetlsid||'_BASE';
atrrDataName:='LS'||allnetlsid||'_ATTR_DATA';
localscanexp:='LS'||allnetlsid||'_LOCAL_SCAN_EXPORT';
exp:='LS'||allnetlsid||'_EXPORT';

containerName0:='LS'||spesficnetlsid||'_CONTAINER';
baseName0:='LS'||spesficnetlsid||'_BASE';
atrrDataName0:='LS'||spesficnetlsid||'_ATTR_DATA';
localscanexp0:='LS'||spesficnetlsid||'_LOCAL_SCAN_EXPORT';
exp0:='LS'||spesficnetlsid||'_EXPORT';

execute immediate 'TRUNCATE table temp_element_full_names';
execute immediate 'TRUNCATE table element_graph';

execute immediate 'insert into temp_element_full_names select name from '||baseName||' where element_full_name = '''||'root.types.resource.network'||'''  and name in ('||includenets||' )';
SELECT_CASCADE;
execute immediate 'create table ctmp_element_graph as select * from element_graph';

execute immediate 'TRUNCATE table temp_element_full_names';
execute immediate 'TRUNCATE table element_graph';

execute immediate 'insert into temp_element_full_names select name from '||baseName||' where element_full_name = '''||'root.types.resource.network'||'''  and name not in ('||includenets||' )';

SELECT_CASCADE;

execute immediate 'delete from element_graph where element_id in (select * from ctmp_element_graph)';
execute immediate 'create table ctmp_hpvse as select ELEMENT_ID vseid, char_value from '||atrrDataName||' where ELEMENT_ID in(select ELEMENT_ID from '||atrrDataName||'  where CHAR_VALUE='''||'HP VSE'||''')and  attribute_name = '''||'deviceSerialNumber'||'''';
execute immediate 'create table ctmp_hpvsedel as select DISTINCT b.vseid from (select ELEMENT_ID, char_value from '||atrrDataName||' where ELEMENT_ID in (select * from element_graph)) a inner join ctmp_hpvse b on a.CHAR_VALUE=b.char_value';

execute immediate 'insert into element_graph select * from ctmp_hpvsedel';

execute immediate 'create table ctmp_dupSolarisDev as select CHILD_ELEMENT_ID from '||containerName||' where element_id in ( select element_id from '||containerName||' where  CHILD_ELEMENT_ID in (select ID from '||baseName||' where label like '''||'Solaris Global Zone global with Serial Number%'||''' and ID IN (SELECT ELEMENT_ID FROM ELEMENT_GRAPH))) and CHILD_ELEMENT_ID not in (select * from element_graph)';

execute immediate 'insert into element_graph select * from ctmp_dupSolarisDev';

execute immediate 'create table ctmp_vchostnames as select DISTINCT element_id as esxhostid, char_value as vchostname from '||atrrDataName||' where attribute_name like '''||'vCenterHost'||'''';

execute immediate 'create table ctmp_vchostid as select DISTINCT ID,ctmp_vchostnames.* from '||baseName||',ctmp_vchostnames where LABEL LIKE '''||'%''||ctmp_vchostnames.VCHOSTNAME||''%'||''' and ELEMENT_FULL_NAME like '''||'%operatingSystem%'||''' and id in (select * from element_graph)';

execute immediate 'create table ctmp_virSystemIdentifier as select * from  '||atrrDataName||' where attribute_name like '''||'virtualizedSystemIdentifier'||''' and element_id in (select esxhostid from ctmp_vchostid)';

execute immediate 'create table ctmp_dupVMwareDev as select ID from '||baseName||',ctmp_virSystemIdentifier where label like '''||'VMware Virtualization Device ''||ctmp_virSystemIdentifier.CHAR_VALUE||'''||'''';

execute immediate 'insert into element_graph select * from ctmp_dupVMwareDev';

get_unknowndev(baseName);

dbms_output.put_line(atrrDataName);
execute immediate 'CREATE TABLE '||atrrDataName0||' as select * from '||atrrDataName||'  where ELEMENT_ID not in (select * from element_graph)';
dbms_output.put_line(localscanexp);
execute immediate 'CREATE TABLE '||localscanexp0||' as select * from '||localscanexp||'';
execute immediate 'CREATE TABLE '||exp0||' as select * from '||exp||'';
execute immediate 'CREATE TABLE '||baseName0||' as select * from '||baseName||' where id not in (select * from element_graph)';
execute immediate 'CREATE TABLE '||containerName0||' as select * from '||containerName||' where ELEMENT_ID not in (select * from element_graph) and CHILD_ELEMENT_ID not in (select * from element_graph)';

dbms_output.put_line(baseName0);
execute immediate 'select count(*)  from '||baseName0||'' into elecount;
execute immediate 'select count(*)  from '||atrrDataName0||'' into datacount;
execute immediate 'select count(*)  from '||containerName0||'' into contacount;

dbms_output.put_line(elecount);

execute immediate 'update local_scan set id='||spesficnetlsid||'+1 where id='||spesficnetlsid||'';
execute immediate 'create table ctmp_temp1 as select * from local_scan where id='||allnetlsid||'';

execute immediate 'update ctmp_temp1 set id='||spesficnetlsid||'';
execute immediate 'update ctmp_temp1 set name = '||csname||'';
execute immediate 'update ctmp_temp1 set description = '||csname||'';
execute immediate 'update ctmp_temp1 set DATA_COUNT='||datacount||'';
execute immediate 'update ctmp_temp1 set ELEMENT_COUNT='||elecount||'';
execute immediate 'update ctmp_temp1 set container_count='||contacount||'';

execute immediate 'insert into local_scan select * from ctmp_temp1';

Declare cursor dropCtmptb is select table_name from user_tables WHERE TABLE_NAME like '%CTMP_%';
Var01 varchar (80);
Begin
Open dropCtmptb;
Loop
   fetch dropCtmptb into Var01;
   exit when dropCtmptb %notfound;
   execute immediate 'drop table '||Var01||' ';
End Loop;
End;

End;
/
