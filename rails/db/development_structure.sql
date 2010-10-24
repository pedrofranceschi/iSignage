CREATE TABLE "commands" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" integer, "name" varchar(255), "value" varchar(255), "executed" boolean DEFAULT 'f', "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "active" boolean DEFAULT 't', "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "password" varchar(255), "email" varchar(255), "full_name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20101016032745');

INSERT INTO schema_migrations (version) VALUES ('20101016035445');

INSERT INTO schema_migrations (version) VALUES ('20101016044317');