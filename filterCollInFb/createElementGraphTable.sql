create or replace procedure select_cascade
as
    element_count NUMBER;    
    baseName varchar(30);
    lsid NUMBER;
    
begin
    execute immediate 'truncate table temp_cas_id_1';
    execute immediate 'truncate table temp_cas_id_2';
    lsid :=&1; 
    baseName :='LS'||lsid||'_BASE';
    execute immediate 'insert into temp_cas_id_1
    select id
        from '||baseName||'
        where name in (
            select element_full_name
            from temp_element_full_names)';

    insert into element_graph select element_id from temp_cas_id_1;

    element_count := SQL%ROWCOUNT;

    commit;

    IF 0 < element_count THEN
        select_cas_recursion(1);
    END IF;
end select_cascade;
/
create or replace procedure select_cas_recursion (use_cas_id_1 in number)
as
    parents_table VARCHAR2(256);
    children_table VARCHAR2(256);
    children_count NUMBER;
    containerName varchar(30);
    lsid NUMBER;
begin
    IF 1 = use_cas_id_1 THEN
        parents_table := 'temp_cas_id_1';
        children_table := 'temp_cas_id_2';
    ELSE
        parents_table := 'temp_cas_id_2';
        children_table := 'temp_cas_id_1';
        
    END IF;
    lsid :=&1;
    containerName :='LS'||lsid||'_CONTAINER';
    /* Select all the child elements under the elements which are not in the
       element_graph table into the parents_table */
    execute immediate
        'insert into ' || children_table || ' ' ||
        'select child_element_id ' ||
        'from ' || parents_table || ' pt, '||containerName||' ' ||
        'where pt.element_id = '||containerName||'.element_id ' ||
        '    and '||containerName||'.active=1 ' ||
        'MINUS ' ||
        'select element_id from element_graph ';

    children_count := SQL%ROWCOUNT;

    execute immediate
        'insert into element_graph ' ||
        'select * from ' || children_table;

    execute immediate
        'truncate table ' || parents_table;

    commit;

    /* If the children count is 0, stop the
     * breadth-first search, otherwise contine
     * the width-first search.
     */
    IF 0 < children_count THEN
        IF 0 = use_cas_id_1 THEN
            select_cas_recursion(1);
        ELSE
            select_cas_recursion(0);
        END IF;
    END IF;
end select_cas_recursion;
/


create or replace procedure get_unknowndev (tbn varchar) as
TYPE t_cur IS REF CURSOR; 
getdevs t_cur;
Var01 varchar (30);
Var02 number;
containerName varchar(30);
baseName varchar(30);
lsid NUMBER;
l_cur        VARCHAR2(4000);  

Begin
Var02 :=0;
lsid :=&1;
baseName :='LS'||lsid||'_BASE';
containerName :='LS'||lsid||'_CONTAINER';
l_cur := 'select ID from '||tbn||' where label like ''%Guests''';
Open getdevs for l_cur ;
Loop
       fetch getdevs into Var01;
       exit when getdevs %notfound;
       execute immediate 'SELECT count(*) FROM '||baseName||' WHERE  ID IN (SELECT CHILD_ELEMENT_ID FROM '||containerName||' WHERE ELEMENT_ID IN (SELECT CHILD_ELEMENT_ID FROM '||containerName||' WHERE ELEMENT_ID='||Var01||')) AND ID not IN (SELECT * FROM ELEMENT_GRAPH)' into Var02;
       dbms_output.put_line(Var02);
       if Var02=0 then
       execute immediate 'insert into element_graph values('''||Var01||''')';
       end if;
End Loop;
close getdevs;
End;
/
