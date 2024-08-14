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
    preferenciaAnimais BOOLEAN NOT NULL, -- Preferência por animais, não nulo
    preferenciaCigarro BOOLEAN NOT NULL, -- Preferência por cigarro, não nulo
    preferenciaMusica BOOLEAN NOT NULL, -- Preferência por música, não nulo
    preferenciaConversa BOOLEAN NOT NULL,
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
                       ano INT CHECK (ano >= 1900 AND ano <= EXTRACT(YEAR FROM CURRENT_DATE)) -- Ano do carro, entre 1900 e o ano atual
);

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
    horaChegada TIMESTAMP NOT NULL -- Hora de chegada da viagem, não nulo
);

CREATE TABLE caronas
(
    id SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada carona
    viagemID INT NOT NULL UNIQUE, -- ID da viagem associada, que deve ser único e refere-se a uma viagem existente
    status BOOLEAN NOT NULL, -- Indica se a carona já aconteceu ou não, não nulo
    reservaAutomatica BOOLEAN NOT NULL, -- Indica se a reserva é automática, não nulo
    assentosLivres INT NOT NULL, -- Quantidade de assentos livres na carona, não nulo
    FOREIGN KEY (viagemID) REFERENCES viagens (id) ON DELETE CASCADE -- Chave estrangeira para a tabela de viagens
);

CREATE TABLE onibus
(
    numeracao VARCHAR(20) PRIMARY KEY, -- Numeração do ônibus, chave primária
    empresa VARCHAR(100) NOT NULL, -- Empresa do ônibus, não nulo
    status BOOLEAN NOT NULL, -- Indica se a viagem de ônibus já aconteceu ou não, não nulo
    classe VARCHAR(50) NOT NULL, -- Classe do ônibus, não nulo
    wifi BOOLEAN NOT NULL, -- Indica se o ônibus tem Wi-Fi, não nulo
    banheiros BOOLEAN NOT NULL, -- Indica se o ônibus tem banheiros, não nulo
    arcondicionado BOOLEAN NOT NULL, -- Indica se o ônibus tem ar-condicionado, não nulo
    tomadas BOOLEAN NOT NULL, -- Indica se o ônibus tem tomadas, não nulo
    assentoreclinavel BOOLEAN NOT NULL, -- Indica se o ônibus tem assento reclinável, não nulo
    viagemID INT NOT NULL, -- ID da viagem associada, não nulo
    FOREIGN KEY (viagemID) REFERENCES viagens (id) -- Chave estrangeira para a tabela de viagens
);

CREATE TABLE conducao
(
    placa VARCHAR(8) NOT NULL, -- Placa do carro, chave estrangeira
    motoristaID INT NOT NULL, -- ID do motorista, chave estrangeira
    PRIMARY KEY (placa, motoristaID), -- Chave primária composta
    FOREIGN KEY (placa) REFERENCES carros (placa) ON DELETE CASCADE, -- Referência para a tabela de carros
    FOREIGN KEY (motoristaID) REFERENCES motoristas (id) ON DELETE CASCADE -- Referência para a tabela de motoristas
);

CREATE TABLE deslocamento
(
    viagemID INT NOT NULL,  -- ID da viagem, chave estrangeira
    rotaID INT NOT NULL,    -- ID da rota, chave estrangeira
    PRIMARY KEY (viagemID, rotaID), -- Chave primária composta
    FOREIGN KEY (viagemID) REFERENCES viagens (id) ON DELETE CASCADE, -- Referência para a tabela de viagens
    FOREIGN KEY (rotaID) REFERENCES rotas (id) ON DELETE CASCADE -- Referência para a tabela de rotas
);

CREATE TABLE reserva
(
    caronaID INT NOT NULL, -- ID da carona, chave estrangeira
    passageiroID INT NOT NULL, -- ID do passageiro, chave estrangeira
    quantidadePassageiros INT NOT NULL, -- Quantidade de passageiros na reserva de um único usuário, não nulo
    PRIMARY KEY (caronaID, passageiroID), -- Chave primária composta
    FOREIGN KEY (caronaID) REFERENCES caronas (id) ON DELETE CASCADE, -- Referência para a tabela de caronas
    FOREIGN KEY (passageiroID) REFERENCES passageiros (id) ON DELETE CASCADE -- Referência para a tabela de passageiros
);

CREATE TABLE oferta
(
    caronaID INT NOT NULL, -- ID da carona, chave estrangeira
    motoristaID INT NOT NULL, -- ID do motorista, chave estrangeira
    vai2Atras BOOLEAN NOT NULL, -- Indica se o motorista irá garantir um banco livre atrás, não nulo
    descricao TEXT, -- Descrição da carona, opcional
    PRIMARY KEY (caronaID, motoristaID), -- Chave primária composta
    FOREIGN KEY (caronaID) REFERENCES caronas (id) ON DELETE CASCADE, -- Referência para a tabela de caronas
    FOREIGN KEY (motoristaID) REFERENCES motoristas (id) ON DELETE CASCADE -- Referência para a tabela de motoristas
);

CREATE TABLE assento
(
    numeracaoOnibus VARCHAR(20) NOT NULL, -- Numeração do ônibus, não nulo
    passageiroID INT NOT NULL, -- ID do passageiro, não nulo
    numeroAssento INT NOT NULL, -- Número do assento no ônibus, não nulo
    PRIMARY KEY (numeracaoOnibus, passageiroID), -- Chave primária composta
    FOREIGN KEY (numeracaoOnibus) REFERENCES onibus (numeracao), -- Referência para a tabela de ônibus
    FOREIGN KEY (passageiroID) REFERENCES passageiros (id) -- Referência para a tabela de passageiros
);

------------------------------------------------------ INSERCOES -------------------------------------------------------

-- Insercao de 60 usuarios
INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('João Silva', 'joao.silva@gmail.com', '(82) 98552-6571', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Maria Oliveira', 'maria.oliveira@gmail.com', '(93) 98663-0067', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Carlos Souza', 'carlos.souza@gmail.com', '(66) 99636-7135', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Ana Lima', 'ana.lima@gmail.com', '(16) 98933-4989', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Pedro Santos', 'pedro.santos@gmail.com', '(27) 99809-1713', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Julia Costa', 'julia.costa@gmail.com', '(84) 97552-5639', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Marcos Pereira', 'marcos.pereira@gmail.com', '(91) 99502-4623', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Fernanda Almeida', 'fernanda.almeida@gmail.com', '(85) 97125-4254', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Ricardo Mendes', 'ricardo.mendes@gmail.com', '(95) 98532-6465', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Patricia Rocha', 'patricia.rocha@gmail.com', '(68) 97417-4659', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Lucas Ferreira', 'lucas.ferreira@gmail.com', '(11) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gabriela Lima', 'gabriela.lima@gmail.com', '(21) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rafael Costa', 'rafael.costa@gmail.com', '(31) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Beatriz Almeida', 'beatriz.almeida@gmail.com', '(41) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Felipe Santos', 'felipe.santos@gmail.com', '(51) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Larissa Oliveira', 'larissa.oliveira@gmail.com', '(61) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Bruno Pereira', 'bruno.pereira@gmail.com', '(71) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Amanda Souza', 'amanda.souza@gmail.com', '(81) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rodrigo Mendes', 'rodrigo.mendes@gmail.com', '(91) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Juliana Rocha', 'juliana.rocha@gmail.com', '(92) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Thiago Martins', 'thiago.martins@gmail.com', '(93) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Camila Silva', 'camila.silva@gmail.com', '(94) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gustavo Lima', 'gustavo.lima@gmail.com', '(95) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Isabela Costa', 'isabela.costa@gmail.com', '(96) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Leonardo Almeida', 'leonardo.almeida@gmail.com', '(97) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Mariana Santos', 'mariana.santos@gmail.com', '(98) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Eduardo Oliveira', 'eduardo.oliveira@gmail.com', '(99) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Renata Pereira', 'renata.pereira@gmail.com', '(21) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Daniel Souza', 'daniel.souza@gmail.com', '(22) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Patricia Mendes', 'patricia.mendes@gmail.com', '(23) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Lucas Ferreira', 'lucas.ferreira2@gmail.com', '(24) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gabriela Lima', 'gabriela.lima2@gmail.com', '(25) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rafael Costa', 'rafael.costa2@gmail.com', '(26) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Beatriz Almeida', 'beatriz.almeida2@gmail.com', '(27) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Felipe Santos', 'felipe.santos2@gmail.com', '(28) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Larissa Oliveira', 'larissa.oliveira2@gmail.com', '(29) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Bruno Pereira', 'bruno.pereira2@gmail.com', '(30) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Amanda Souza', 'amanda.souza2@gmail.com', '(31) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rodrigo Mendes', 'rodrigo.mendes2@gmail.com', '(32) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Juliana Rocha', 'juliana.rocha2@gmail.com', '(33) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Thiago Martins', 'thiago.martins2@gmail.com', '(34) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Camila Silva', 'camila.silva2@gmail.com', '(35) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gustavo Lima', 'gustavo.lima2@gmail.com', '(36) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Isabela Costa', 'isabela.costa2@gmail.com', '(37) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Leonardo Almeida', 'leonardo.almeida2@gmail.com', '(38) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Mariana Santos', 'mariana.santos2@gmail.com', '(39) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Eduardo Oliveira', 'eduardo.oliveira2@gmail.com', '(40) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Renata Pereira', 'renata.pereira2@gmail.com', '(41) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Daniel Souza', 'daniel.souza2@gmail.com', '(42) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Patricia Mendes', 'patricia.mendes2@gmail.com', '(43) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Lucas Ferreira', 'lucas.ferreira3@gmail.com', '(44) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gabriela Lima', 'gabriela.lima3@gmail.com', '(45) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rafael Costa', 'rafael.costa3@gmail.com', '(46) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Beatriz Almeida', 'beatriz.almeida3@gmail.com', '(47) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Felipe Santos', 'felipe.santos3@gmail.com', '(48) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Larissa Oliveira', 'larissa.oliveira3@gmail.com', '(49) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Bruno Pereira', 'bruno.pereira3@gmail.com', '(50) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Amanda Souza', 'amanda.souza3@gmail.com', '(51) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rodrigo Mendes', 'rodrigo.mendes3@gmail.com', '(52) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Juliana Rocha', 'juliana.rocha3@gmail.com', '(53) 90123-4567', 'Passageira que gosta de música durante a viagem');

-- Insercao de 15 usuários como motoristas
INSERT INTO motoristas (id, preferenciaAnimais, preferenciaCigarro, preferenciaMusica, preferenciaConversa, quantidadeCaronas)
VALUES (6, TRUE, FALSE, TRUE, FALSE, 9),
       (10, FALSE, TRUE, FALSE, TRUE, 15),
       (11, TRUE, TRUE, FALSE, FALSE, 73),
       (14, FALSE, FALSE, TRUE, TRUE, 3),
       (18, TRUE, FALSE, FALSE, TRUE, 6),
       (19, FALSE, TRUE, TRUE, FALSE, 12),
       (20, TRUE, TRUE, TRUE, FALSE, 1),
       (22, FALSE, FALSE, FALSE, TRUE, 4),
       (24, TRUE, FALSE, TRUE, TRUE, 9),
       (35, FALSE, TRUE, FALSE, FALSE, 11),
       (37, TRUE, TRUE, FALSE, TRUE, 159),
       (41, FALSE, FALSE, TRUE, FALSE, 56),
       (49, TRUE, TRUE, TRUE, TRUE, 6),
       (50, FALSE, FALSE, FALSE, FALSE, 91),
       (58, TRUE, FALSE, TRUE, FALSE, 20);

-- Insercao de 30 usuários como passageiros
INSERT INTO passageiros (id, localizacaoAtual)
VALUES (1, 'Av. Ipiranga, 13981'),
       (3, 'Rua dos Andradas, 12345'),
       (5, 'Av. Protásio Alves, 25789'),
       (7, 'Rua Padre Chagas, 4012'),
       (8, 'Av. Carlos Gomes, 15432'),
       (9, 'Rua da Praia, 2345'),
       (12, 'Av. Bento Gonçalves, 31234'),
       (13, 'Rua 24 de Outubro, 5678'),
       (15, 'Av. Farrapos, 10987'),
       (16, 'Rua João Alfredo, 6789'),
       (17, 'Av. Assis Brasil, 43210'),
       (21, 'Rua Ramiro Barcelos, 7890'),
       (23, 'Av. Cristóvão Colombo, 8765'),
       (25, 'Rua Mariante, 9876'),
       (26, 'Av. Independência, 11223'),
       (27, 'Rua Mostardeiro, 12321'),
       (28, 'Av. Getúlio Vargas, 13456'),
       (29, 'Rua Dona Laura, 14567'),
       (30, 'Av. Plinio Brasil Milano, 15678'),
       (31, 'Rua Vicente da Fontoura, 16789'),
       (32, 'Av. João Pessoa, 17890'),
       (33, 'Rua General Vitorino, 18901'),
       (34, 'Av. Borges de Medeiros, 19012'),
       (36, 'Rua Coronel Bordini, 20123'),
       (38, 'Av. Sertório, 21234'),
       (39, 'Rua Santana, 22345'),
       (40, 'Av. Loureiro da Silva, 23456'),
       (42, 'Rua Barão do Amazonas, 24567'),
       (53, 'Av. Azenha, 25678'),
       (60, 'Rua São Manoel, 26789');

-- Insercao de 100 avaliações entre usuários
INSERT INTO avaliacoes (mensagem, nota, avaliadorID, avaliadoID)
VALUES
('Ótima viagem!', 5, 41, 12),
('Motorista muito educado.', 4, 30, 41),
('Viagem tranquila.', 5, 15, 60),
('Gostei muito da conversa.', 5, 17, 28),
('Carro confortável.', 4, 29, 10),
('Motorista pontual.', 5, 11, 12),
('Viagem rápida e segura.', 5, 53, 14),
('Muito simpático.', 4, 35, 6),
('Recomendo a todos.', 5, 57, 18),
('Boa música durante a viagem.', 4, 39, 20),
('Motorista atencioso.', 5, 29, 22),
('Viagem agradável.', 5, 53, 14),
('Motorista experiente.', 5, 35, 26),
('Viagem tranquila e segura.', 5, 7, 28),
('Muito educado.', 4, 2, 31),
('Carro limpo e confortável.', 5, 31, 32),
('Motorista prestativo.', 5, 33, 34),
('Viagem excelente.', 5, 35, 36),
('Muito pontual.', 4, 37, 38),
('Recomendo.', 5, 39, 40),
('Ótima experiência.', 5, 41, 42),
('Motorista cuidadoso.', 5, 43, 44),
('Viagem segura.', 5, 45, 46),
('Muito simpático e educado.', 4, 47, 48),
('Carro confortável e limpo.', 5, 49, 50),
('Motorista muito bom.', 5, 51, 52),
('Viagem tranquila e rápida.', 5, 53, 54),
('Muito atencioso.', 4, 55, 56),
('Recomendo a todos.', 5, 57, 58),
('Boa música durante a viagem.', 4, 59, 60),
('Motorista atencioso.', 5, 1, 3),
('Viagem agradável.', 5, 5, 7),
('Motorista experiente.', 5, 6, 8),
('Viagem tranquila e segura.', 5, 9, 11),
('Muito educado.', 4, 10, 12),
('Carro limpo e confortável.', 5, 13, 15),
('Motorista prestativo.', 5, 14, 16),
('Viagem excelente.', 5, 17, 18),
('Muito pontual.', 4, 19, 20),
('Recomendo.', 5, 21, 22),
('Ótima experiência.', 5, 23, 24),
('Motorista cuidadoso.', 5, 25, 26),
('Viagem segura.', 5, 27, 28),
('Muito simpático e educado.', 4, 29, 30),
('Carro confortável e limpo.', 5, 31, 32),
('Motorista muito bom.', 5, 33, 34),
('Viagem tranquila e rápida.', 5, 35, 36),
('Muito atencioso.', 4, 37, 38),
('Recomendo a todos.', 5, 39, 40),
('Boa música durante a viagem.', 4, 41, 42),
('Motorista atencioso.', 5, 43, 44),
('Viagem agradável.', 5, 45, 46),
('Motorista experiente.', 5, 47, 48),
('Viagem tranquila e segura.', 5, 49, 50),
('Muito educado.', 4, 51, 52),
('Carro limpo e confortável.', 5, 53, 54),
('Motorista prestativo.', 5, 55, 56),
('Viagem excelente.', 5, 57, 58),
('Muito pontual.', 4, 59, 60),
('Recomendo.', 5, 1, 3),
('Ótima viagem!', 5, 4, 6),
('Motorista muito educado.', 4, 7, 9),
('Viagem tranquila.', 5, 10, 12),
('Gostei muito da conversa.', 5, 13, 15),
('Carro confortável.', 4, 16, 18),
('Motorista pontual.', 5, 19, 21),
('Viagem rápida e segura.', 5, 22, 24),
('Muito simpático.', 4, 25, 27),
('Recomendo a todos.', 5, 28, 30),
('Boa música durante a viagem.', 4, 31, 33),
('Motorista atencioso.', 5, 34, 36),
('Viagem agradável.', 5, 37, 39),
('Motorista experiente.', 5, 40, 42),
('Viagem tranquila e segura.', 5, 43, 45),
('Muito educado.', 4, 46, 48),
('Carro limpo e confortável.', 5, 49, 51),
('Motorista prestativo.', 5, 52, 54),
('Viagem excelente.', 5, 55, 57),
('Muito pontual.', 4, 58, 60),
('Recomendo.', 5, 1, 3),
('Ótima experiência.', 5, 4, 6),
('Motorista cuidadoso.', 5, 7, 9),
('Viagem segura.', 5, 10, 12),
('Muito simpático e educado.', 4, 13, 15),
('Carro confortável e limpo.', 5, 16, 18),
('Motorista muito bom.', 5, 19, 21),
('Viagem tranquila e rápida.', 5, 22, 24),
('Muito atencioso.', 4, 25, 27),
('Recomendo a todos.', 5, 28, 30),
('Boa música durante a viagem.', 4, 31, 33),
('Motorista atencioso.', 5, 34, 36),
('Viagem agradável.', 5, 37, 39),
('Motorista experiente.', 5, 40, 42),
('Viagem tranquila e segura.', 5, 43, 45),
('Muito educado.', 4, 46, 48),
('Carro limpo e confortável.', 5, 49, 51),
('Motorista prestativo.', 5, 52, 54),
('Viagem excelente.', 5, 55, 57),
('Muito pontual.', 4, 58, 60),
('Viagem tranquila.', 5, 5, 13);

-- Insercao de 38 carros
INSERT INTO carros (placa, modelo, marca, ano) VALUES
('MUO-3085', 'Civic', 'Honda', 2018),
('IBF-5385', 'Corolla', 'Toyota', 2019),
('JFO-5921', 'Model S', 'Tesla', 2020),
('NEN-9859', 'Mustang', 'Ford', 2017),
('GCW-6838', 'Camry', 'Toyota', 2016),
('HPI-0051', 'Accord', 'Honda', 2015),
('LWV-8090', 'Altima', 'Nissan', 2014),
('VWX-8Y67', '3 Series', 'BMW', 2013),
('YZA-9Z89', 'A4', 'Audi', 2012),
('BCD-0A12', 'C-Class', 'Mercedes-Benz', 2011),
('MXM-4733', 'Impreza', 'Subaru', 2010),
('MUJ-0936', 'Mazda3', 'Mazda', 2009),
('KHM-3D78', 'Golf', 'Volkswagen', 2008),
('GFP-4E90', 'Elantra', 'Hyundai', 2007),
('ISS-5F12', 'Focus', 'Ford', 2006),
('RBV-6G34', 'Jetta', 'Volkswagen', 2005),
('IWY-7H56', 'Fusion', 'Ford', 2004),
('FMB-8I78', 'Optima', 'Kia', 2003),
('CEE-9J90', 'Sonata', 'Hyundai', 2002),
('MGH-0K12', 'Passat', 'Volkswagen', 1991),
('QWK-1L34', 'Legacy', 'Subaru', 2009),
('TEN-2M56', 'Outback', 'Subaru', 2006),
('EWQ-3N78', 'CX-5', 'Mazda', 2015),
('IUT-4O90', 'RAV4', 'Toyota', 2020),
('UVW-5P12', 'CR-V', 'Honda', 2018),
('QWZ-6Q34', 'Escape', 'Ford', 2010),
('TSC-7R56', 'Rogue', 'Nissan', 2017),
('QWF-8S78', 'Tiguan', 'Volkswagen', 2024),
('RWI-9T90', 'Q5', 'Audi', 2019),
('QGL-0U12', 'X3', 'BMW', 2015),
('BNO-1V34', 'GLC', 'Mercedes-Benz', 2012),
('PER-2W56', 'Macan', 'Porsche', 2020),
('FDU-3X78', 'XC60', 'Volvo', 2012),
('VGX-4Y90', 'Cherokee', 'Jeep', 2022),
('WQA-5Z12', 'Grand Cherokee', 'Jeep', 2009),
('QWD-6A34', 'Wrangler', 'Jeep', 2010),
('OSG-7B56', 'Compass', 'Jeep', 2020),
('IIJ-8C78', 'Renegade', 'Jeep', 2023);

-- Insercao de 57 rotas
INSERT INTO rotas (origem, destino, distancia) VALUES
('Sao Paulo', 'Rio de Janeiro', 430),
('Sao Paulo', 'Belo Horizonte', 590),
('Sao Paulo', 'Curitiba', 400),
('Sao Paulo', 'Porto Alegre', 1100),
('Sao Paulo', 'Salvador', 1500),
('Rio de Janeiro', 'Belo Horizonte', 340),
('Rio de Janeiro', 'Curitiba', 800),
('Rio de Janeiro', 'Porto Alegre', 1200),
('Rio de Janeiro', 'Salvador', 1100),
('Belo Horizonte', 'Curitiba', 820),
('Belo Horizonte', 'Porto Alegre', 1300),
('Belo Horizonte', 'Salvador', 950),
('Curitiba', 'Porto Alegre', 500),
('Curitiba', 'Salvador', 1150),
('Porto Alegre', 'Salvador', 1600),
('Sao Paulo', 'Brasilia', 1000),
('Rio de Janeiro', 'Brasilia', 1050),
('Belo Horizonte', 'Brasilia', 740),
('Curitiba', 'Brasilia', 950),
('Porto Alegre', 'Brasilia', 1300),
('Salvador', 'Brasilia', 850),
('Sao Paulo', 'Fortaleza', 2200),
('Rio de Janeiro', 'Fortaleza', 2300),
('Belo Horizonte', 'Fortaleza', 1900),
('Curitiba', 'Fortaleza', 2100),
('Porto Alegre', 'Fortaleza', 2400),
('Salvador', 'Fortaleza', 500),
('Sao Paulo', 'Recife', 2300),
('Rio de Janeiro', 'Recife', 2400),
('Belo Horizonte', 'Recife', 2000),
('Curitiba', 'Recife', 2200),
('Porto Alegre', 'Recife', 2500),
('Salvador', 'Recife', 550),
('Sao Paulo', 'Manaus', 3300),
('Rio de Janeiro', 'Manaus', 3400),
('Belo Horizonte', 'Manaus', 3000),
('Curitiba', 'Manaus', 3200),
('Porto Alegre', 'Manaus', 3500),
('Salvador', 'Manaus', 3500),
('Sao Paulo', 'Belém', 2900),
('Rio de Janeiro', 'Belém', 3000),
('Belo Horizonte', 'Belém', 2700),
('Curitiba', 'Belém', 2900),
('Porto Alegre', 'Belém', 3200),
('Salvador', 'Belém', 3000),
('Sao Paulo', 'Sao Luis', 2800),
('Rio de Janeiro', 'Sao Luis', 2900),
('Belo Horizonte', 'Sao Luis', 2500),
('Curitiba', 'Sao Luis', 2700),
('Porto Alegre', 'Sao Luis', 3000),
('Salvador', 'Sao Luis', 2900),
('Sao Paulo', 'Joao Pessoa', 2200),
('Rio de Janeiro', 'Joao Pessoa', 2300),
('Belo Horizonte', 'Joao Pessoa', 2000),
('Curitiba', 'Joao Pessoa', 2200),
('Porto Alegre', 'Joao Pessoa', 2500),
('Salvador', 'Joao Pessoa', 550);

-- Insercao de 70 viagens
INSERT INTO viagens (preco, data, horaSaida, horaChegada) VALUES
(100, '2023-10-01 08:00:00', '2023-10-01 08:00:00', '2023-10-01 12:00:00'),
(150, '2023-10-02 09:00:00', '2023-10-02 09:00:00', '2023-10-02 13:00:00'),
(200, '2023-10-03 10:00:00', '2023-10-03 10:00:00', '2023-10-03 14:00:00'),
(120, '2023-10-04 11:00:00', '2023-10-04 11:00:00', '2023-10-04 15:00:00'),
(180, '2023-10-05 12:00:00', '2023-10-05 12:00:00', '2023-10-05 16:00:00'),
(130, '2023-10-06 13:00:00', '2023-10-06 13:00:00', '2023-10-06 17:00:00'),
(170, '2023-10-07 14:00:00', '2023-10-07 14:00:00', '2023-10-07 18:00:00'),
(140, '2023-10-08 15:00:00', '2023-10-08 15:00:00', '2023-10-08 19:00:00'),
(160, '2023-10-09 16:00:00', '2023-10-09 16:00:00', '2023-10-09 20:00:00'),
(110, '2023-10-10 17:00:00', '2023-10-10 17:00:00', '2023-10-10 21:00:00'),
(100, '2023-10-11 08:00:00', '2023-10-11 08:00:00', '2023-10-11 12:00:00'),
(150, '2023-10-12 09:00:00', '2023-10-12 09:00:00', '2023-10-12 13:00:00'),
(200, '2023-10-13 10:00:00', '2023-10-13 10:00:00', '2023-10-13 14:00:00'),
(120, '2023-10-14 11:00:00', '2023-10-14 11:00:00', '2023-10-14 15:00:00'),
(180, '2023-10-15 12:00:00', '2023-10-15 12:00:00', '2023-10-15 16:00:00'),
(130, '2023-10-16 13:00:00', '2023-10-16 13:00:00', '2023-10-16 17:00:00'),
(170, '2023-10-17 14:00:00', '2023-10-17 14:00:00', '2023-10-17 18:00:00'),
(140, '2023-10-18 15:00:00', '2023-10-18 15:00:00', '2023-10-18 19:00:00'),
(160, '2023-10-19 16:00:00', '2023-10-19 16:00:00', '2023-10-19 20:00:00'),
(110, '2023-10-20 17:00:00', '2023-10-20 17:00:00', '2023-10-20 21:00:00'),
(100, '2023-10-21 08:00:00', '2023-10-21 08:00:00', '2023-10-21 12:00:00'),
(150, '2023-10-22 09:00:00', '2023-10-22 09:00:00', '2023-10-22 13:00:00'),
(200, '2023-10-23 10:00:00', '2023-10-23 10:00:00', '2023-10-23 14:00:00'),
(120, '2023-10-24 11:00:00', '2023-10-24 11:00:00', '2023-10-24 15:00:00'),
(180, '2023-10-25 12:00:00', '2023-10-25 12:00:00', '2023-10-25 16:00:00'),
(130, '2023-10-26 13:00:00', '2023-10-26 13:00:00', '2023-10-26 17:00:00'),
(170, '2023-10-27 14:00:00', '2023-10-27 14:00:00', '2023-10-27 18:00:00'),
(140, '2023-10-28 15:00:00', '2023-10-28 15:00:00', '2023-10-28 19:00:00'),
(160, '2023-10-29 16:00:00', '2023-10-29 16:00:00', '2023-10-29 20:00:00'),
(110, '2023-10-30 17:00:00', '2023-10-30 17:00:00', '2023-10-30 21:00:00'),
(100, '2023-10-31 08:00:00', '2023-10-31 08:00:00', '2023-10-31 12:00:00'),
(150, '2023-11-01 09:00:00', '2023-11-01 09:00:00', '2023-11-01 13:00:00'),
(200, '2023-11-02 10:00:00', '2023-11-02 10:00:00', '2023-11-02 14:00:00'),
(120, '2023-11-03 11:00:00', '2023-11-03 11:00:00', '2023-11-03 15:00:00'),
(180, '2023-11-04 12:00:00', '2023-11-04 12:00:00', '2023-11-04 16:00:00'),
(130, '2023-11-05 13:00:00', '2023-11-05 13:00:00', '2023-11-05 17:00:00'),
(170, '2023-11-06 14:00:00', '2023-11-06 14:00:00', '2023-11-06 18:00:00'),
(140, '2023-11-07 15:00:00', '2023-11-07 15:00:00', '2023-11-07 19:00:00'),
(160, '2023-11-08 16:00:00', '2023-11-08 16:00:00', '2023-11-08 20:00:00'),
(110, '2023-11-09 17:00:00', '2023-11-09 17:00:00', '2023-11-09 21:00:00'),
(100, '2023-11-10 08:00:00', '2023-11-10 08:00:00', '2023-11-10 12:00:00'),
(150, '2023-11-11 09:00:00', '2023-11-11 09:00:00', '2023-11-11 13:00:00'),
(200, '2023-11-12 10:00:00', '2023-11-12 10:00:00', '2023-11-12 14:00:00'),
(120, '2023-11-13 11:00:00', '2023-11-13 11:00:00', '2023-11-13 15:00:00'),
(180, '2023-11-14 12:00:00', '2023-11-14 12:00:00', '2023-11-14 16:00:00'),
(130, '2023-11-15 13:00:00', '2023-11-15 13:00:00', '2023-11-15 17:00:00'),
(170, '2023-11-16 14:00:00', '2023-11-16 14:00:00', '2023-11-16 18:00:00'),
(140, '2023-11-17 15:00:00', '2023-11-17 15:00:00', '2023-11-17 19:00:00'),
(160, '2023-11-18 16:00:00', '2023-11-18 16:00:00', '2023-11-18 20:00:00'),
(110, '2023-11-19 17:00:00', '2023-11-19 17:00:00', '2023-11-19 21:00:00'),
(100, '2023-11-20 08:00:00', '2023-11-20 08:00:00', '2023-11-20 12:00:00'),
(150, '2023-11-21 09:00:00', '2023-11-21 09:00:00', '2023-11-21 13:00:00'),
(200, '2023-11-22 10:00:00', '2023-11-22 10:00:00', '2023-11-22 14:00:00'),
(120, '2023-11-23 11:00:00', '2023-11-23 11:00:00', '2023-11-23 15:00:00'),
(180, '2023-11-24 12:00:00', '2023-11-24 12:00:00', '2023-11-24 16:00:00'),
(130, '2023-11-25 13:00:00', '2023-11-25 13:00:00', '2023-11-25 17:00:00'),
(170, '2023-11-26 14:00:00', '2023-11-26 14:00:00', '2023-11-26 18:00:00'),
(140, '2023-11-27 15:00:00', '2023-11-27 15:00:00', '2023-11-27 19:00:00'),
(160, '2023-11-28 16:00:00', '2023-11-28 16:00:00', '2023-11-28 20:00:00'),
(110, '2023-11-29 17:00:00', '2023-11-29 17:00:00', '2023-11-29 21:00:00'),
(100, '2023-11-30 08:00:00', '2023-11-30 08:00:00', '2023-11-30 12:00:00'),
(150, '2023-12-01 09:00:00', '2023-12-01 09:00:00', '2023-12-01 13:00:00'),
(200, '2023-12-02 10:00:00', '2023-12-02 10:00:00', '2023-12-02 14:00:00'),
(120, '2023-12-03 11:00:00', '2023-12-03 11:00:00', '2023-12-03 15:00:00'),
(180, '2023-12-04 12:00:00', '2023-12-04 12:00:00', '2023-12-04 16:00:00'),
(130, '2023-12-05 13:00:00', '2023-12-05 13:00:00', '2023-12-05 17:00:00'),
(170, '2023-12-06 14:00:00', '2023-12-06 14:00:00', '2023-12-06 18:00:00'),
(140, '2023-12-07 15:00:00', '2023-12-07 15:00:00', '2023-12-07 19:00:00'),
(160, '2023-12-08 16:00:00', '2023-12-08 16:00:00', '2023-12-08 20:00:00'),
(110, '2023-12-09 17:00:00', '2023-12-09 17:00:00', '2023-12-09 21:00:00');

--Insercao de 55 caronas
INSERT INTO caronas (viagemID, status, reservaAutomatica, assentosLivres) VALUES
(1, TRUE, FALSE, 4),
(4, TRUE, TRUE, 2),
(5, FALSE, TRUE, 0),
(6, TRUE, FALSE, 4),
(7, TRUE, TRUE, 2),
(9, TRUE, FALSE, 4),
(11, FALSE, TRUE, 3),
(12, TRUE, FALSE, 2),
(13, TRUE, TRUE, 4),
(14, FALSE, TRUE, 1),
(15, TRUE, FALSE, 3),
(17, FALSE, TRUE, 0),
(18, TRUE, FALSE, 4),
(19, TRUE, TRUE, 1),
(20, FALSE, TRUE, 3),
(21, TRUE, FALSE, 2),
(22, TRUE, TRUE, 4),
(23, FALSE, TRUE, 0),
(24, TRUE, FALSE, 4),
(27, TRUE, FALSE, 1),
(29, FALSE, TRUE, 3),
(30, TRUE, FALSE, 2),
(31, TRUE, TRUE, 0),
(32, FALSE, TRUE, 4),
(33, TRUE, FALSE, 1),
(34, TRUE, TRUE, 3),
(35, FALSE, TRUE, 2),
(37, TRUE, TRUE, 0),
(38, FALSE, TRUE, 3),
(39, TRUE, FALSE, 2),
(40, TRUE, TRUE, 4),
(41, FALSE, TRUE, 1),
(45, TRUE, FALSE, 3),
(46, TRUE, TRUE, 1),
(47, FALSE, TRUE, 4),
(48, TRUE, FALSE, 2),
(49, TRUE, TRUE, 3),
(50, FALSE, TRUE, 0),
(51, TRUE, FALSE, 4),
(53, FALSE, TRUE, 2),
(54, TRUE, FALSE, 3),
(55, TRUE, TRUE, 4),
(57, TRUE, FALSE, 2),
(58, TRUE, TRUE, 4),
(59, FALSE, TRUE, 1),
(60, TRUE, FALSE, 3),
(61, TRUE, TRUE, 0),
(62, FALSE, TRUE, 4),
(63, TRUE, FALSE, 2),
(64, TRUE, TRUE, 3),
(65, FALSE, TRUE, 1),
(67, TRUE, TRUE, 2),
(68, FALSE, TRUE, 3),
(69, TRUE, FALSE, 0),
(70, TRUE, TRUE, 4);

-- Insercao de 15 onibus
INSERT INTO onibus (numeracao, empresa, status, classe, wifi, banheiros, arcondicionado, tomadas, assentoreclinavel, viagemID) VALUES
('NN31O', 'Santo Anjo', TRUE, 'Executivo', TRUE, TRUE, TRUE, TRUE, TRUE, 66),
('ON002', 'Viacao Ouro e Prata', FALSE, 'Convencional', TRUE, TRUE, FALSE, TRUE, FALSE, 56),
('L6K5G', 'Eucatur', TRUE, 'Leito', FALSE, TRUE, TRUE, FALSE, TRUE, 52),
('NN44O', 'Santo Anjo', FALSE, 'Executivo', TRUE, FALSE, TRUE, TRUE, TRUE, 44),
('ON005', 'Itapemirim', TRUE, 'Convencional', TRUE, TRUE, FALSE, TRUE, FALSE, 43),
('L3K5S', 'Eucatur', FALSE, 'Leito', TRUE, TRUE, TRUE, TRUE, TRUE, 42),
('ON007', 'Expresso Azul', TRUE, 'Executivo', FALSE, TRUE, TRUE, TRUE, TRUE, 36),
('NN142', 'Santo Anjo', FALSE, 'Convencional', TRUE, TRUE, FALSE, FALSE, TRUE, 28),
('T0J2M', 'Freders Expresso', TRUE, 'Leito', TRUE, TRUE, TRUE, TRUE, FALSE, 26),
('M2X8C', 'Cadutur', FALSE, 'Executivo', FALSE, TRUE, TRUE, TRUE, TRUE, 25),
('ON011', 'Unesul', TRUE, 'Convencional', TRUE, TRUE, FALSE, TRUE, TRUE, 16),
('P4Q7Y', 'Adamantina', FALSE, 'Leito', TRUE, TRUE, TRUE, FALSE, TRUE, 10),
('L9K4W', 'Eucatur', TRUE, 'Executivo', TRUE, FALSE, TRUE, TRUE, TRUE, 8),
('NN665', 'Santo Anjo', FALSE, 'Convencional', TRUE, TRUE, FALSE, TRUE, FALSE, 2),
('ON014', 'Unesul', TRUE, 'Leito', TRUE, TRUE, TRUE, TRUE, TRUE, 3);

-- Insercao da relacao entre motoristas e carros
INSERT INTO conducao (placa, motoristaID) VALUES
('MUO-3085', 6),
('IBF-5385', 10),
('JFO-5921', 11),
('NEN-9859', 14),
('GCW-6838', 18),
('HPI-0051', 19),
('LWV-8090', 20),
('VWX-8Y67', 22),
('YZA-9Z89', 24),
('BCD-0A12', 35),
('MXM-4733', 37),
('MUJ-0936', 41),
('KHM-3D78', 49),
('GFP-4E90', 50),
('ISS-5F12', 58);

-- Inserir da relacao entre carona e motorista
INSERT INTO oferta (caronaID, motoristaID, vai2Atras, descricao) VALUES
(1, 6, TRUE, 'Vai ter um banco livre atrás para mais conforto.'),
(4, 10, FALSE, 'Será uma viagem rápida, sem muita conversa.'),
(5, 11, TRUE, 'Música rolando durante todo o caminho.'),
(6, 14, FALSE, 'Ambiente tranquilo, sem barulho.'),
(7, 18, TRUE, 'Ar-condicionado no ponto para o calor.'),
(9, 19, FALSE, 'Apenas passageiros com bagagens de mão, por favor.'),
(11, 20, TRUE, 'Tem espaço para suas malas.'),
(12, 22, FALSE, 'Vamos sair e chegar no horário certinho.'),
(13, 24, TRUE, 'Motorista com muita experiência no volante.'),
(14, 35, FALSE, 'Sou educado e tranquilo, viagem sem estresse.'),
(15, 37, TRUE, 'Cuidarei bem do trajeto.'),
(17, 41, FALSE, 'Por favor, pagamentos no embarque.'),
(18, 49, TRUE, 'Viagem sem pressa e boa conversa.'),
(19, 50, FALSE, 'Motorista atento ao que está acontecendo.'),
(20, 58, TRUE, 'Muita experiência no volante.');

-- Insercao da relacao entre carona e passageiros
INSERT INTO reserva (caronaID, passageiroID, quantidadePassageiros) VALUES
(1, 1, 1),
(4, 3, 2),
(5, 5, 1),
(6, 7, 3),
(7, 8, 2),
(9, 9, 1),
(11, 12, 2),
(12, 13, 1),
(13, 15, 3),
(14, 16, 2),
(15, 17, 1),
(17, 21, 2),
(18, 23, 1),
(19, 25, 3),
(20, 26, 2),
(21, 27, 1),
(22, 28, 2),
(23, 29, 1),
(24, 30, 3),
(27, 31, 2),
(29, 32, 1),
(30, 33, 2),
(31, 34, 1),
(32, 36, 3),
(33, 38, 2);