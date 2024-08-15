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

CREATE TABLE avalia
(
    avaliadorID INT NOT NULL, -- ID do usuário que fez a avaliação
    avaliadoID INT NOT NULL, -- ID do usuário que foi avaliado
    avaliacaoID INT NOT NULL, -- ID da avaliação
    PRIMARY KEY (avaliadorID, avaliadoID, avaliacaoID), -- Chave primária composta
    FOREIGN KEY (avaliadorID) REFERENCES usuarios (id) ON DELETE CASCADE, -- Referência para a tabela de usuários
    FOREIGN KEY (avaliadoID) REFERENCES usuarios (id) ON DELETE CASCADE, -- Referência para a tabela de usuários
    FOREIGN KEY (avaliacaoID) REFERENCES avaliacoes (id) ON DELETE CASCADE -- Referência para a tabela de avaliações
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

-- Inserção de 50 instâncias na tabela assento
INSERT INTO assento (numeracaoOnibus, passageiroID, numeroAssento) VALUES
('NN31O', 21, 14),
('NN31O', 1, 24),
('NN31O', 3, 51),
('ON002', 12, 4),
('ON002', 53, 5),
('ON002', 13, 56),
('L6K5G', 23, 47),
('L6K5G', 60, 84),
('L6K5G', 3, 77),
('NN44O', 28, 51),
('NN44O', 40, 91),
('NN44O', 36, 29),
('ON005', 16, 67),
('ON005', 15, 42),
('ON005', 3, 16),
('L3K5S', 12, 7),
('L3K5S', 53, 44),
('L3K5S', 13, 78),
('ON007', 16, 59),
('ON007', 27, 10),
('ON007', 39, 71),
('NN142', 1, 22),
('NN142', 30, 23),
('NN142', 12, 24),
('T0J2M', 5, 45),
('T0J2M', 23, 31),
('T0J2M', 30, 53),
('M2X8C', 9, 11),
('M2X8C', 5, 1),
('M2X8C', 36, 98),
('ON011', 40, 87),
('ON011', 9, 65),
('ON011', 29, 12),
('P4Q7Y', 17, 21),
('P4Q7Y', 21, 65),
('P4Q7Y', 1, 51),
('L9K4W', 33, 64),
('L9K4W', 60, 38),
('L9K4W', 38, 49),
('NN665', 39, 10),
('NN665', 15, 12),
('NN665', 3, 44),
('ON014', 17, 73),
('ON014', 30, 34),
('ON014', 36, 74),
('NN31O', 42, 41),
('ON002', 5, 64),
('L6K5G', 53, 18),
('NN44O', 15, 92),
('ON005', 25, 50);

-- Insercoes de deslocamentos para todas viagens
INSERT INTO deslocamento (viagemID, rotaID) VALUES
(1, 1),
(1, 7),
(1, 13),
(2, 15),
(3, 17),
(4, 2),
(4, 12),
(5, 3),
(6, 4),
(7, 5),
(8, 5),
(9, 33),
(10, 40),
(11, 1),
(11, 7),
(12, 28),
(13, 19),
(14, 33),
(15, 7),
(17, 48),
(18, 21),
(19, 32),
(20, 6),
(20, 30),
(21, 40),
(22, 2),
(23, 55),
(24, 17),
(27, 13),
(29, 4),
(30, 25),
(31, 38),
(32, 8),
(33, 30),
(34, 1),
(35, 20),
(37, 47),
(38, 19),
(39, 26),
(40, 54),
(41, 10),
(45, 31),
(46, 16),
(47, 28),
(48, 39),
(49, 15),
(50, 52),
(51, 33),
(53, 24),
(54, 37),
(55, 49),
(57, 42),
(58, 35),
(59, 46),
(60, 51),
(61, 43),
(62, 44),
(63, 57),
(64, 12),
(65, 9),
(67, 5),
(68, 41),
(69, 27),
(70, 50);

-- Insercao de 450 avaliacoes entre usuarios
INSERT INTO avalia (avaliadorID, avaliadoID, avaliacaoID) VALUES
(27, 23, 179),
(6, 48, 194),
(20, 50, 117),
(35, 15, 106),
(19, 42, 157),
(60, 9, 116),
(12, 26, 165),
(6, 29, 187),
(26, 25, 199),
(9, 23, 159),
(26, 46, 111),
(43, 10, 167),
(29, 52, 175),
(41, 24, 101),
(56, 31, 160),
(7, 9, 197),
(26, 3, 187),
(51, 9, 168),
(19, 15, 141),
(39, 26, 168),
(38, 52, 154),
(39, 53, 142),
(5, 8, 170),
(12, 31, 150),
(20, 9, 160),
(59, 36, 168),
(18, 57, 103),
(5, 18, 170),
(11, 52, 157),
(31, 38, 123),
(4, 33, 116),
(50, 32, 132),
(7, 17, 141),
(38, 45, 101),
(13, 28, 152),
(39, 38, 108),
(6, 54, 165),
(24, 13, 131),
(31, 33, 159),
(1, 55, 129),
(7, 3, 186),
(58, 15, 167),
(56, 38, 165),
(46, 43, 106),
(47, 21, 159),
(55, 50, 116),
(49, 37, 175),
(46, 45, 151),
(25, 11, 166),
(39, 36, 167),
(50, 15, 180),
(13, 12, 130),
(24, 38, 140),
(5, 60, 189),
(21, 60, 196),
(32, 44, 139),
(42, 33, 183),
(42, 23, 180),
(35, 24, 182),
(46, 54, 115),
(29, 39, 198),
(47, 8, 189),
(59, 11, 157),
(1, 17, 114),
(11, 38, 155),
(36, 1, 101),
(16, 16, 181),
(46, 1, 138),
(46, 50, 112),
(1, 24, 194),
(46, 27, 175),
(5, 53, 168),
(54, 34, 157),
(9, 4, 163),
(38, 4, 159),
(6, 23, 161),
(11, 59, 158),
(38, 48, 111),
(48, 34, 114),
(46, 54, 191),
(8, 4, 105),
(22, 18, 119),
(52, 32, 131),
(58, 18, 139),
(3, 48, 192),
(36, 16, 113),
(10, 30, 127),
(37, 18, 169),
(39, 30, 188),
(33, 6, 180),
(7, 12, 106),
(19, 17, 135),
(19, 17, 147),
(26, 21, 133),
(5, 58, 137),
(26, 40, 172),
(17, 34, 188),
(54, 42, 197),
(44, 14, 117),
(1, 42, 188),
(27, 4, 179),
(53, 35, 136),
(37, 13, 139),
(20, 57, 153),
(46, 54, 152),
(53, 16, 197),
(39, 26, 191),
(39, 41, 117),
(43, 15, 109),
(18, 60, 189),
(40, 20, 149),
(27, 21, 128),
(41, 26, 171),
(22, 14, 114),
(37, 45, 174),
(17, 14, 111),
(31, 35, 104),
(20, 36, 128),
(23, 11, 115),
(24, 17, 165),
(39, 2, 172),
(24, 40, 156),
(57, 24, 131),
(52, 20, 191),
(32, 2, 122),
(21, 59, 151),
(17, 1, 111),
(42, 11, 198),
(55, 19, 105),
(46, 55, 187),
(60, 8, 106),
(3, 34, 174),
(13, 19, 190),
(37, 40, 189),
(37, 41, 117),
(56, 60, 198),
(23, 53, 101),
(53, 11, 187),
(3, 8, 197),
(39, 23, 110),
(5, 41, 101),
(19, 43, 153),
(58, 13, 157),
(6, 44, 176),
(49, 14, 140),
(40, 49, 156),
(5, 42, 145),
(14, 38, 120),
(7, 48, 126),
(57, 17, 141),
(26, 47, 164),
(25, 48, 168),
(3, 17, 133),
(26, 14, 151),
(38, 57, 125),
(8, 1, 131),
(46, 16, 129),
(9, 25, 120),
(13, 5, 186),
(54, 19, 146),
(5, 28, 192),
(1, 19, 127),
(24, 8, 173),
(4, 53, 127),
(48, 38, 146),
(33, 5, 176),
(40, 58, 194),
(54, 7, 120),
(25, 37, 116),
(38, 55, 180),
(54, 56, 139),
(51, 23, 167),
(18, 49, 102),
(33, 40, 140),
(21, 52, 118),
(1, 48, 184),
(5, 35, 152),
(58, 5, 148),
(50, 10, 107),
(47, 12, 119),
(25, 45, 162),
(60, 4, 121),
(15, 6, 162),
(44, 39, 129),
(21, 46, 128),
(26, 50, 111),
(45, 2, 115),
(23, 48, 147),
(41, 46, 103),
(30, 27, 135),
(32, 31, 116),
(29, 10, 123),
(57, 43, 171),
(50, 47, 193),
(24, 7, 147),
(28, 42, 169),
(43, 5, 138),
(54, 19, 171),
(11, 37, 199),
(47, 2, 184),
(10, 18, 167),
(37, 26, 179),
(30, 23, 174),
(40, 17, 197),
(36, 55, 172),
(29, 23, 108),
(48, 42, 186),
(18, 36, 191),
(41, 2, 110),
(11, 20, 185),
(32, 21, 198),
(18, 29, 198),
(9, 25, 166),
(16, 16, 145),
(24, 55, 193),
(51, 54, 137),
(34, 20, 147),
(31, 52, 178),
(54, 51, 127),
(41, 42, 101),
(19, 15, 111),
(56, 51, 167),
(37, 33, 188),
(3, 35, 120),
(1, 28, 184),
(56, 27, 106),
(29, 21, 180),
(47, 25, 180),
(23, 46, 153),
(48, 2, 185),
(25, 45, 198),
(47, 37, 152),
(48, 27, 150),
(6, 54, 157),
(40, 56, 121),
(35, 16, 149),
(16, 8, 145),
(49, 28, 181),
(9, 20, 174),
(42, 57, 176),
(42, 49, 163),
(26, 4, 155),
(33, 11, 149),
(55, 16, 118),
(4, 33, 149),
(51, 36, 195),
(6, 24, 117),
(50, 52, 118),
(44, 16, 130),
(54, 26, 101),
(40, 21, 179),
(12, 40, 114),
(17, 26, 148),
(22, 35, 120),
(50, 40, 118),
(41, 33, 167),
(14, 28, 140),
(25, 12, 176),
(25, 22, 113),
(6, 17, 157),
(41, 43, 119),
(53, 6, 101),
(26, 3, 198),
(30, 58, 186),
(52, 15, 149),
(51, 13, 134),
(56, 26, 195),
(13, 31, 185),
(56, 43, 102),
(36, 2, 111),
(14, 10, 115),
(41, 10, 184),
(9, 20, 108),
(30, 22, 109),
(15, 45, 143),
(22, 25, 184),
(36, 7, 165),
(49, 28, 179),
(42, 53, 119),
(44, 16, 125),
(21, 48, 197),
(3, 53, 108),
(5, 16, 109),
(7, 38, 189),
(32, 58, 124),
(3, 46, 190),
(14, 24, 108),
(5, 21, 141),
(9, 37, 189),
(36, 3, 111),
(33, 7, 101),
(36, 52, 171),
(12, 25, 148),
(27, 59, 180),
(50, 16, 156),
(41, 54, 141),
(34, 54, 166),
(35, 27, 180),
(42, 58, 191),
(37, 26, 166),
(5, 19, 138),
(7, 4, 162),
(25, 60, 131),
(45, 43, 104),
(36, 30, 177),
(43, 19, 178),
(58, 35, 127),
(17, 47, 127),
(57, 54, 124),
(13, 16, 126),
(36, 10, 197),
(5, 51, 194),
(49, 29, 199),
(18, 31, 162),
(25, 8, 162),
(25, 18, 138),
(29, 33, 116),
(20, 21, 162),
(40, 12, 190),
(4, 20, 101),
(17, 2, 118),
(16, 23, 152),
(3, 29, 143),
(18, 40, 129),
(21, 3, 192),
(46, 13, 117),
(46, 57, 188),
(33, 5, 121),
(10, 15, 145),
(45, 10, 172),
(55, 37, 168),
(50, 40, 167),
(11, 51, 142),
(44, 13, 153),
(46, 3, 144),
(60, 23, 163),
(42, 44, 151),
(2, 38, 173),
(25, 31, 127),
(53, 3, 164),
(24, 53, 119),
(27, 50, 161),
(60, 40, 144),
(24, 41, 198),
(28, 27, 101),
(21, 38, 154),
(19, 45, 195),
(13, 35, 154),
(60, 28, 155),
(14, 2, 130),
(24, 9, 148),
(41, 57, 102),
(18, 58, 119),
(37, 53, 133),
(38, 52, 126),
(39, 6, 178),
(45, 29, 103),
(9, 51, 108),
(23, 40, 142),
(9, 7, 124),
(48, 47, 186),
(12, 57, 109),
(23, 45, 197),
(52, 20, 123),
(29, 11, 164),
(45, 58, 114),
(26, 58, 101),
(34, 28, 130),
(4, 8, 159),
(17, 33, 139),
(15, 33, 195),
(39, 8, 173),
(58, 28, 132),
(6, 38, 188),
(7, 41, 198),
(59, 18, 184),
(60, 15, 166),
(44, 4, 164),
(40, 10, 153),
(31, 19, 197),
(32, 14, 105),
(22, 18, 142),
(34, 43, 127),
(4, 56, 136),
(26, 42, 153),
(47, 12, 155),
(19, 57, 197),
(36, 46, 188),
(48, 58, 124),
(9, 27, 178),
(8, 2, 152),
(55, 56, 101),
(28, 3, 110),
(17, 49, 177),
(35, 29, 172),
(43, 34, 190),
(8, 27, 127),
(39, 33, 166),
(53, 38, 163),
(47, 36, 139),
(22, 43, 195),
(47, 36, 164),
(27, 15, 180),
(34, 24, 167),
(3, 5, 169),
(57, 36, 175),
(52, 50, 188),
(40, 26, 166),
(24, 18, 145),
(46, 41, 166),
(26, 55, 148),
(3, 47, 175),
(15, 10, 152),
(42, 10, 198),
(59, 34, 173),
(27, 51, 183),
(2, 1, 133),
(15, 34, 101),
(46, 11, 116),
(4, 26, 153),
(27, 45, 157),
(23, 60, 163),
(10, 1, 106),
(53, 38, 114),
(2, 35, 135),
(34, 8, 146),
(21, 5, 163),
(60, 32, 193),
(2, 20, 198),
(35, 41, 169),
(57, 3, 138),
(11, 14, 146),
(8, 30, 142),
(24, 4, 143),
(33, 56, 144),
(11, 4, 196),
(24, 23, 104),
(47, 58, 198),
(58, 3, 168),
(28, 22, 111),
(49, 29, 183),
(14, 40, 147),
(10, 17, 150),
(32, 38, 141),
(39, 37, 129),
(36, 60, 184),
(56, 42, 107),
(43, 48, 148),
(9, 54, 157),
(35, 3, 104);
