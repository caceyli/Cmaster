select 'select '''+[name]+''' dbmc,[name],[filename],convert(float,size) * (8192.0/1024.0)/1024 sizes from ['+[name]+'].dbo.sysfiles union all' From master.dbo.sysdatabases where dbid>4;
select 'BDNA' dbmc,[name],[filename],convert(float,size) * (8192.0/1024.0)/1024 sizes from [BDNA].dbo.sysfiles union all select 'BDNA_PUBLISH' dbmc,[name],[filename],convert(float,size) * (8192.0/1024.0)/1024 sizes from [BDNA_PUBLISH].dbo.sysfiles;
update BDNA_A_PROPERTIES$ set VALUE_DATE='1969-12-31 00:00:00:000' where PROPERTY like '%LAST_MODIFIED_DATE%%';
update nbf_sys_files set status='NONE' where file_name like '5.5.17%';
