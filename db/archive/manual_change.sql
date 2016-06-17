////////////////////////////////////////////
// OWNERSHIP
////////////////////////////////////////////

CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

psql clearboxstudios_production -c 'create extension hstore;'
psql clearboxstudios_production -c 'create extension unaccent;'
psql clearboxstudios_production -c 'create extension pg_trgm;'



truncate table account_users;
truncate table accounts;
truncate table invoices;
truncate table profiles;
truncate table projects;
truncate table tasks;



alter table account_users owner to web_admin;
alter table accounts owner to web_admin;
alter table invoices owner to web_admin;
alter table profiles owner to web_admin;
alter table projects owner to web_admin;
alter table tasks owner to web_admin;
alter table users owner to web_admin;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE credits TO railsapp_user;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE user_credits TO railsapp_user;


grant select, insert, update, delete on account_users to railsapp_user;
grant select, insert, update, delete on accounts to railsapp_user;
grant select, insert, update, delete on invoices to railsapp_user;
grant select, insert, update, delete on profiles to railsapp_user;
grant select, insert, update, delete on projects to railsapp_user;
grant select, insert, update, delete on tasks to railsapp_user;
grant select, insert, update, delete on users to railsapp_user;


grant select, insert, update, delete on project_documents to railsapp_user;
grant select, insert, update, delete on project_photos to railsapp_user;
grant select, insert, update, delete on project_videos to railsapp_user;



grant select, usage, update, delete on account_users_id_seq to railsapp_user;
grant select, usage, update, delete on accounts_id_seq to railsapp_user;
grant select, usage, update, delete on invoices_id_seq to railsapp_user;
grant select, usage, update, delete on profiles_id_seq to railsapp_user;
grant select, usage, update, delete on projects_id_seq to railsapp_user;
grant select, usage, update, delete on tasks_id_seq to railsapp_user;
grant select, usage, update, delete on users_id_seq to railsapp_user;






ALTER SEQUENCE account_users_id_seq RESTART WITH 127128;
ALTER SEQUENCE accounts_id_seq RESTART WITH 127128;
ALTER SEQUENCE invoices_id_seq RESTART WITH 127128;
ALTER SEQUENCE profiles_id_seq RESTART WITH 127127;
ALTER SEQUENCE projects_id_seq RESTART WITH 127128;
ALTER SEQUENCE tasks_id_seq RESTART WITH 127128;
ALTER SEQUENCE users_id_seq RESTART WITH 127127;





////////////////////////////////////////////
// TASKS
////////////////////////////////////////////

ALTER TABLE tasks DROP CONSTRAINT tasks_pkey;
ALTER TABLE tasks rename to tasksold;
DROP INDEX index_tasks_on_project_id;


CREATE TABLE tasks
(
  id serial NOT NULL,
  project_id integer,
  staff_id integer,
  category character varying(255),
  task_type character varying(255),
  title character varying(255),
  description text,
  status character varying(255),
  hours_estimate numeric,
  hours_actual numeric,
  rate_estimate numeric,
  rate_actual numeric,
  staff_rate_estimate numeric,
  staff_rate_actual numeric,
  start date,
  "end" date,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT tasks_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE tasks
  OWNER TO railsapp_user;

-- Index: index_tasks_on_project_id

-- DROP INDEX index_tasks_on_project_id;

CREATE INDEX index_tasks_on_project_id
  ON tasks
  USING btree
  (project_id);


INSERT INTO tasks
(
  project_id,
  staff_id,
  category,
  title,
  description,
  status,
  hours_estimate,
  rate_estimate,
  rate_actual,
  staff_rate_estimate,
  staff_rate_actual,
  start,
  "end",
  created_at,
  updated_at
  )
  
SELECT 
  project_id,
  staff_id,
  category,
  title,
  description,
  status,
  hours_estimate,
  rate_estimate,
  rate_actual,
  staff_rate_estimate,
  staff_rate_actual,
  start,
  "end",
  created_at,
  updated_at
FROM TASKSOLD;



DROP TABLE tasksold;
ALTER SEQUENCE tasks_id_seq1 RENAME TO tasks_id_seq;
ALTER TABLE tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);

ALTER TABLE tasks RENAME COLUMN type TO task_type;













////////////////////////////////////////////
// PROFILES
////////////////////////////////////////////

ALTER TABLE profiles
DROP COLUMN created_at,
DROP COLUMN updated_at
;

ALTER TABLE profiles
 ADD COLUMN  staff_member boolean,
 ADD COLUMN  website_links hstore,
 ADD COLUMN  image_links hstore,
 ADD COLUMN  created_at timestamp without time zone,
 ADD COLUMN  updated_at timestamp without time zone 
;

UPDATE profiles
set created_at = now(), updated_at = now();

ALTER TABLE profiles
 ALTER COLUMN created_at SET NOT NULL,
 ALTER COLUMN updated_at SET NOT NULL
;


CREATE INDEX profiles_gin_website_links ON profiles USING GIN(website_links);
CREATE INDEX profiles_gin_image_links ON profiles USING GIN(image_links); 



////////////////////////////////////////////

ALTER TABLE profiles
DROP COLUMN created_at,
DROP COLUMN updated_at
;
DROP INDEX profiles_gin_website_links;

ALTER TABLE profiles
 RENAME COLUMN  website_links TO contact_links,
 ADD COLUMN  privacy_settings hstore,
 ADD COLUMN  created_at timestamp without time zone,
 ADD COLUMN  updated_at timestamp without time zone 
;

UPDATE profiles
set created_at = now(), updated_at = now();

ALTER TABLE profiles
 ALTER COLUMN created_at SET NOT NULL,
 ALTER COLUMN updated_at SET NOT NULL
;

CREATE INDEX profiles_gin_contact_links ON profiles USING GIN(contact_links);
CREATE INDEX profiles_gin_privacy_settings ON profiles USING GIN(privacy_settings); 



////////////////////////////////////////////





ALTER TABLE profiles DROP CONSTRAINT profiles_pkey;
ALTER TABLE profiles rename to profilesold;
DROP INDEX index_profiles_on_user_id;
DROP INDEX profiles_gin_image_links;
DROP INDEX profiles_gin_contact_links;


CREATE TABLE profiles
(
  id serial NOT NULL,
  user_id integer,
  name_first character varying(255),
  name_middle character varying(255),
  name_last character varying(255),

  phone_home character varying(255),
  phone_work character varying(255),
  phone_mobile character varying(255),

  address_street text,
  address_city character varying(255),
  address_state character varying(255),
  address_zip character varying(255),

  job_title character varying(255),
  job_description text,
  company_name character varying(255),
  company_website text,
  contact_email character varying(255),

  profile_description text,
  staff_member boolean,

  contact_links hstore,
  image_links hstore,
  privacy_settings hstore,  

  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT profiles_pkey PRIMARY KEY (id)
);

ALTER TABLE profiles OWNER TO web_admin;
GRANT ALL ON TABLE profiles TO web_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE profiles TO railsapp_user;

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);
CREATE INDEX profiles_gin_image_links ON profiles USING gin (image_links);
CREATE INDEX profiles_gin_contact_links ON profiles USING gin (contact_links);
CREATE INDEX profiles_gin_privacy_settings ON profiles USING gin (privacy_settings);


INSERT INTO profiles
SELECT 
    id,
    user_id,
    name_first,
    name_middle,
    name_last,
    phone_home,
    phone_work,
    phone_mobile,
    address_street,
    address_city,
    address_state,
    address_zip,
    company_name,
    company_website,
    job_title,
    job_description,
    profile_description,
    staff_member,
    contact_links,
    image_links,
    created_at,
    updated_at
    FROM profiles;


DROP TABLE profilesold;
ALTER SEQUENCE profiles_id_seq1 RENAME TO profiles_id_seq;
ALTER TABLE profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);




////////////////////////////////////////////
// Postgres 9.2
////////////////////////////////////////////

curl -O http://yum.postgresql.org/9.2/redhat/rhel-6-i386/pgdg-centos92-9.2-6.noarch.rpm
rpm -ivh pgdg-centos92-9.2-6.noarch.rpm

yum install postgresql92-server
yum install postgresql92-contrib
yum install postgresql92-devel


/usr/pgsql-9.2/bin/pg_upgrade -b /usr/bin/ -B /usr/pgsql-9.2/bin/ -d /var/lib/pgsql/data/ -D /var/lib/pgsql/9.2/data


diff /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf
diff /var/lib/pgsql/data/postgresql.conf /var/lib/pgsql/9.2/data/postgresql.conf


cp /var/lib/pgsql/9.2/data/postgresql.conf /home/webadmin/postgresql.conf.84

rm /var/lib/pgsql/data/pg_hba.conf
cp /home/webadmin/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf


chkconfig postgresql off
chkconfig postgresql-9.2 on




////////////////////////////////////////////
// Accounts
////////////////////////////////////////////


ALTER TABLE accounts DROP CONSTRAINT accounts_pkey;
ALTER TABLE accounts rename to accountsold;

CREATE TABLE accounts
(
  id serial NOT NULL,
  name character varying(255),
  
  company_name character varying(255),
  company_website character varying(255),
  company_phone character varying(255),
  company_address_street character varying(255),
  company_address_city character varying(255),
  company_address_state character varying(255),
  company_address_zip character varying(255),  
  
  billing_name character varying(255),
  billing_email character varying(255),
  billing_phone_home character varying(255),
  billing_phone_work character varying(255),
  billing_phone_mobile character varying(255),
  billing_address_street character varying(255),
  billing_address_city character varying(255),
  billing_address_state character varying(255),
  billing_address_zip character varying(255),

  permissions integer,
  
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT accounts_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE accounts
  OWNER TO web_admin;
GRANT ALL ON TABLE accounts TO web_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE accounts TO railsapp_user;




INSERT INTO accounts
(
  id,
  name,
  
  company_name,
  company_website,
  company_phone,
  company_address_street,
  company_address_city,
  company_address_state,
  company_address_zip,  
  
  billing_name,
  billing_email,
  billing_phone_home,
  billing_phone_work,
  billing_phone_mobile,
  billing_address_street,
  billing_address_city,
  billing_address_state,
  billing_address_zip,

  permissions,
  
  created_at,
  updated_at
  )
  
SELECT 
  id,
  name,

  company_name,
  company_website, 
  phone_work,
  address_street,
  address_city,
  address_state,
  address_zip,  

  company_name,
  null,
  phone_home,
  phone_work,
  phone_mobile,
  address_street,
  address_city,
  address_state,
  address_zip,  
  null,
  created_at,
  updated_at
FROM accountsold;



DROP TABLE accountsold;
ALTER SEQUENCE accounts_id_seq1 RENAME TO accounts_id_seq;
ALTER TABLE accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);




























////////////////////////////////////////////
// PROJECTS
////////////////////////////////////////////




ALTER TABLE projects DROP CONSTRAINT projects_pkey;
ALTER TABLE projects rename to projectsold;
DROP INDEX index_projects_on_invoice_id;
DROP INDEX index_projects_on_account_id;


CREATE TABLE projects
(
  id serial NOT NULL,
  account_id integer,
  invoice_id integer,
  category character varying(255),
  title character varying(255),
  description text,
  status character varying(255),
  start date,
  "end" date,
  client_contact_id integer,
  internal_contact_id integer,
  permissions integer,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT projects_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE projects
  OWNER TO web_admin;
GRANT ALL ON TABLE projects TO web_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE projects TO railsapp_user;



CREATE INDEX index_projects_on_account_id
  ON projects
  USING btree
  (account_id);



CREATE INDEX index_projects_on_invoice_id
  ON projects
  USING btree
  (invoice_id);






INSERT INTO projects
(
  id,
  account_id,
  invoice_id,
  category,
  title,
  description,
  status,
  start,
  "end",
  client_contact_id,
  internal_contact_id,
  permissions,
  created_at,
  updated_at
  )
  
SELECT 
  id,
  account_id,
  invoice_id,
  category,
  title,
  description,
  status,
  start,
  "end",
  null,
  null,
  null,
  created_at,
  updated_at
FROM projectsold;



DROP TABLE projectsold;
ALTER SEQUENCE projects_id_seq1 RENAME TO projects_id_seq;
ALTER TABLE projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);