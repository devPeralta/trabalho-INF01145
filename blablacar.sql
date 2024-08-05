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
    id           SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada avaliação
    mensagem     TEXT    NOT NULL, -- Mensagem da avaliação, não nula
    nota         INT CHECK (nota >= 1 AND nota <= 5), -- Nota da avaliação, entre 1 e 5
    data         TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora da avaliação, padrão é o momento atual
    avaliadorID INT NOT NULL, -- ID do usuário que fez a avaliação, não nulo
    avaliadoID  INT NOT NULL, -- ID do usuário que foi avaliado, não nulo
    FOREIGN KEY (avaliadorID) REFERENCES usuarios (id), -- Chave estrangeira para a tabela de usuários
    FOREIGN KEY (avaliadoID) REFERENCES usuarios (id) -- Chave estrangeira para a tabela de usuários
);

CREATE TABLE motoristas
(
    id      INT PRIMARY KEY REFERENCES usuarios (id), -- ID do usuário, chave primária e estrangeira
    quantidadeCaronas INT NOT NULL -- Quantidade de caronas dadas pelo motorista, não nula

);

CREATE TABLE passageiros
(
    id INT PRIMARY KEY REFERENCES usuarios (id), -- ID do usuário, chave primária e estrangeira
    localizacaoAtual VARCHAR(100) NOT NULL -- Localização atual do passageiro, não nula
);

CREATE TABLE carros
(
                       placa VARCHAR(8) PRIMARY KEY, -- Placa do carro, chave primária (exemplo: ABC-1D23
                       modelo VARCHAR(20) NOT NULL, -- Modelo do carro, não nulo
                       marca VARCHAR(20) NOT NULL, -- Marca do carro, não nulo
                       ano INT CHECK (ano >= 1900 AND ano <= EXTRACT(YEAR FROM CURRENT_DATE)), -- Ano do carro, entre 1900 e o ano atual
                       motoristaID INT NOT NULL, -- ID do motorista dono do carro, não nulo
                       FOREIGN KEY (motoristaID) REFERENCES motoristas(id) -- Chave estrangeira para a tabela de motoristas
);

/*
CREATE TABLE caronas
(
    id           SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada carona
    origem       VARCHAR(100) NOT NULL, -- Local de origem da carona, não nulo
    destino      VARCHAR(100) NOT NULL, -- Local de destino da carona, não nulo
    data         TIMESTAMP NOT NULL, -- Data e hora da carona, não nulo
    reservaAutomatica BOOLEAN NOT NULL, -- Indica se a reserva é automática, não nulo
    assentosLivres        INT NOT NULL, -- Quantidade de assentos livres na carona, não nulo
    motoristaID  INT NOT NULL, -- ID do motorista que oferece a carona, não nulo
    FOREIGN KEY (motoristaID) REFERENCES motoristas (id) -- Chave estrangeira para a tabela de motoristas
);
 */

CREATE TABLE rotas
(
    id        SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada rota
    origem    VARCHAR(100) NOT NULL, -- Local de origem da rota, não nulo
    destino   VARCHAR(100) NOT NULL, -- Local de destino da rota, não nulo
    distancia INT          NOT NULL -- Distância entre a origem e o destino, não nulo
);

CREATE TABLE viagens
(
    id      SERIAL PRIMARY KEY,    -- ID único e auto-incremental para cada viagem
    preco   INT          NOT NULL, -- Preço da viagem, não nulo
    data    TIMESTAMP    NOT NULL, -- Data e hora da viagem, não nulo
    horaSaida TIMESTAMP NOT NULL, -- Hora de saída da viagem, não nulo
    horaChegada TIMESTAMP NOT NULL, -- Hora de chegada da viagem, não nulo
    rotasID INT NOT NULL, -- ID da rota da viagem, não nulo
    FOREIGN KEY (rotasID) REFERENCES rotas (id) -- Chave estrangeira para a tabela de rotas
);



