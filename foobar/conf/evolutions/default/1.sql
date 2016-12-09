# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table contact_form (
  id                            bigint auto_increment not null,
  uuid                          varchar(255),
  created_at                    DATETIME,
  name                          varchar(255),
  email                         varchar(255),
  version                       bigint not null,
  constraint pk_contact_form primary key (id)
);

create table office (
  id                            bigint auto_increment not null,
  uuid                          varchar(255),
  created_at                    DATETIME,
  name                          varchar(255),
  address                       varchar(255),
  version                       bigint not null,
  constraint pk_office primary key (id)
);


# --- !Downs

drop table if exists contact_form;

drop table if exists office;

