-- auto-generated definition
create table usuarios
(
    id              serial
        primary key,
    nome            varchar(100) not null,
    email           varchar(100) not null
        unique,
    data_nascimento date,
    criado_em       timestamp default CURRENT_TIMESTAMP
);

alter table usuarios
    owner to postgres;

