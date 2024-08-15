-- visao que mostra todas avaliacoes entre usuarios mostrando
-- o nome do avaliador, nome do avaliado, mensagem da avaliacao
-- e a nota dada de um usuario para o outro
CREATE VIEW avaliacoes_usuarios AS
SELECT
    u1.nome AS nome_avaliador,
    u2.nome AS nome_avaliado,
    av.mensagem AS mensagem_da_avaliacao,
    av.nota AS nota_da_avaliacao
FROM
    avalia a
        INNER JOIN
    usuarios u1 ON a.avaliadorID = u1.id
        INNER JOIN
    usuarios u2 ON a.avaliadoID = u2.id
        INNER JOIN
    avaliacoes av ON a.avaliacaoID = av.id
ORDER BY
    u1.dataregistro DESC;

-- consulta que mostra a média e o total de avaliações recebidas de cada usuário
SELECT nome_avaliado, ROUND(AVG(nota_da_avaliacao),2) AS media_avaliacoes, COUNT(nota_da_avaliacao) AS total_avaliacoes
FROM avaliacoes_usuarios
GROUP BY nome_avaliado;

-- consulta que mostra a quantidade de avaliações feitas por cada usuário e ordena por quantidade
SELECT
    nome_avaliador,
    COUNT(*) AS quantidade_avaliacoes
FROM
    avaliacoes_usuarios
GROUP BY
    nome_avaliador
ORDER BY
    quantidade_avaliacoes DESC;

-- consulta que mostra as marcas de carros mais usadas pelos motoristas
SELECT
    c.marca AS marca_carro,
    COUNT(co.placa) AS total_usos
FROM
    conducao co
INNER JOIN
    carros c ON co.placa = c.placa
GROUP BY
    c.marca
HAVING
    COUNT(co.placa) > 0
ORDER BY
    total_usos DESC;

-- consulta que mostra as viagens que não tiveram deslocamento associado, ou seja, um problema de cadastro de viagens
SELECT
    v.id AS id_viagem,
    v.data AS data_viagem
FROM
    viagens v
WHERE
    NOT EXISTS (
        SELECT 1
        FROM deslocamento d
        WHERE d.viagemID = v.id
    );

-- consulta que mostra a quantidade de usuários por DDD
SELECT
SUBSTRING(telefone, 2, 2) AS DDD,
    COUNT(*) AS quantidade_usuarios
FROM
    usuarios
GROUP BY
    SUBSTRING(telefone, 2, 2)
ORDER BY
    quantidade_usuarios DESC;

-- consulta que mostra a quantidade de motoristas que deixam um local vago no banco de trás
SELECT
    (COUNT(CASE WHEN vai2atras = TRUE THEN 1 END) * 100.0 / COUNT(*)) AS porcentagem_motoristas_vai2atras
FROM
    oferta;

-- consulta que mostra informacoes completas sobre cada viagem,
-- sendo que cada viagem tem um ou mais deslocamentos associados
SELECT
    v.id AS id_viagem,
    v.data AS data_viagem,
    v.preco AS preco_viagem,
    r.origem AS origem,
    r.destino AS destino,
    r.distancia AS distancia
FROM
    viagens v
        INNER JOIN
    deslocamento d ON v.id = d.viagemID
        INNER JOIN
    rotas r ON d.rotaID = r.id
ORDER BY
    v.id;