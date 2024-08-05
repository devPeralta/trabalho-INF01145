CREATE TABLE usuarios
(
    id           SERIAL PRIMARY KEY,                 -- ID único e auto-incremental para cada usuário
    nome         VARCHAR(100)       NOT NULL,        -- Nome completo do usuário, não nulo
    email        VARCHAR(50) UNIQUE NOT NULL,        -- E-mail do usuário, único e não nulo
    telefone     VARCHAR(15),                        -- Telefone do usuário, opcional
    sobre        TEXT,                               -- Descrição sobre o usuário, opcional
    dataRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data e hora do registro, padrão é o momento atual
);

CREATE TABLE avaliacoes
(
    id           SERIAL PRIMARY KEY,
    mensagem     TEXT    NOT NULL,
    nota         INT CHECK (nota >= 1 AND nota <= 5),
    data         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    avaliadorID INT NOT NULL,
    avaliadoID  INT NOT NULL,
    FOREIGN KEY (avaliadorID) REFERENCES usuarios (id),
    FOREIGN KEY (avaliadoID) REFERENCES usuarios (id)
);

CREATE TABLE motoristas
(
    id      INT PRIMARY KEY REFERENCES usuarios (id),
    quantidadeCaronas INT NOT NULL

);

CREATE TABLE passageiros
(
    id INT PRIMARY KEY REFERENCES usuarios (id),
    localizacaoAtual VARCHAR(100) NOT NULL
);

