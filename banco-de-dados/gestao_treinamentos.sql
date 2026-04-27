-- =========================================================
-- PROJETO: Sistema de Controle de Treinamentos Institucionais
-- DISCIPLINA: Práticas Extensionistas III
-- DESCRIÇÃO: Banco de dados para controlar treinamentos internos, colaboradores, inscrições, participação e certificados.
-- =========================================================

CREATE DATABASE IF NOT EXISTS gestao_treinamentos;
USE gestao_treinamentos;

-- =========================================================
-- TABELA: area
-- Armazena as áreas/setores da instituição.
-- =========================================================
CREATE TABLE area (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- =========================================================
-- TABELA: pessoa
-- Armazena os colaboradores da instituição.
-- Cada pessoa pertence a uma área.
-- =========================================================
CREATE TABLE pessoa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    cargo VARCHAR(100),
    area_id INT NOT NULL,
    ativo VARCHAR(3) DEFAULT 'Sim',

    CONSTRAINT fk_pessoa_area
        FOREIGN KEY (area_id) REFERENCES area(id)
);

-- =========================================================
-- TABELA: tipo_treinamento
-- Armazena os tipos/categorias dos treinamentos.
-- =========================================================
CREATE TABLE tipo_treinamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    ativo VARCHAR(3) DEFAULT 'Sim'
);

-- =========================================================
-- TABELA: status_treinamento
-- Armazena os possíveis status de um treinamento.
-- =========================================================
CREATE TABLE status_treinamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT
);

-- =========================================================
-- TABELA: local_treinamento
-- Armazena os locais onde os treinamentos podem ocorrer.
-- =========================================================
CREATE TABLE local_treinamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    capacidade INT,
    ativo VARCHAR(3) DEFAULT 'Sim'
);

-- =========================================================
-- TABELA: treinamento
-- Armazena os treinamentos oferecidos pela instituição.
-- =========================================================
CREATE TABLE treinamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME,
    carga_horaria_minutos INT NOT NULL,
    exige_presenca VARCHAR(3) DEFAULT 'Sim',
    instrutor VARCHAR(100) NOT NULL,
    tipo_treinamento_id INT NOT NULL,
    responsavel_pessoa_id INT NOT NULL,
    status_treinamento_id INT NOT NULL,
    local_treinamento_id INT NOT NULL,
    ativo VARCHAR(3) DEFAULT 'Sim',

    CONSTRAINT fk_treinamento_tipo
        FOREIGN KEY (tipo_treinamento_id) REFERENCES tipo_treinamento(id),

    CONSTRAINT fk_treinamento_responsavel
        FOREIGN KEY (responsavel_pessoa_id) REFERENCES pessoa(id),

    CONSTRAINT fk_treinamento_status
        FOREIGN KEY (status_treinamento_id) REFERENCES status_treinamento(id),

    CONSTRAINT fk_treinamento_local
        FOREIGN KEY (local_treinamento_id) REFERENCES local_treinamento(id)
);

-- =========================================================
-- TABELA: status_participacao
-- Armazena os possíveis status da participação de uma pessoa.
-- =========================================================
CREATE TABLE status_participacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT
);

-- =========================================================
-- TABELA: treinamento_participante
-- Relaciona pessoas aos treinamentos.
-- Representa a inscrição/participação do colaborador.
-- =========================================================
CREATE TABLE treinamento_participante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pessoa_id INT NOT NULL,
    treinamento_id INT NOT NULL,
    status_participacao_id INT NOT NULL,
    data_inscricao DATETIME NOT NULL,
    progresso DECIMAL(5,2) DEFAULT 0,
    ativo VARCHAR(3) DEFAULT 'Sim',

    CONSTRAINT fk_participante_pessoa
        FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),

    CONSTRAINT fk_participante_treinamento
        FOREIGN KEY (treinamento_id) REFERENCES treinamento(id),

    CONSTRAINT fk_participante_status
        FOREIGN KEY (status_participacao_id) REFERENCES status_participacao(id)
);

-- =========================================================
-- TABELA: status_certificado
-- Armazena os possíveis status de um certificado.
-- =========================================================
CREATE TABLE status_certificado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT
);

-- =========================================================
-- TABELA: certificado_treinamento
-- Armazena os certificados emitidos para os participantes.
-- =========================================================
CREATE TABLE certificado_treinamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    treinamento_id INT NOT NULL,
    pessoa_id INT NOT NULL,
    status_certificado_id INT NOT NULL,
    data_emissao DATETIME NOT NULL,
    carga_horaria_minutos INT NOT NULL,
    codigo_validacao VARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT fk_certificado_treinamento
        FOREIGN KEY (treinamento_id) REFERENCES treinamento(id),

    CONSTRAINT fk_certificado_pessoa
        FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),

    CONSTRAINT fk_certificado_status
        FOREIGN KEY (status_certificado_id) REFERENCES status_certificado(id)
);

-- =========================================================
-- INSERTS DE DADOS
-- Dados fictícios para demonstração do sistema.
-- =========================================================

INSERT INTO area (nome) VALUES
('Tecnologia da Informação'),
('Enfermagem'),
('Recepção'),
('Faturamento'),
('Recursos Humanos');

INSERT INTO pessoa (nome, email, cargo, area_id, ativo) VALUES
('Arthur Silva', 'arthur@instituicao.com', 'Analista de Sistemas', 1, 'Sim'),
('Mariana Souza', 'mariana@instituicao.com', 'Enfermeira', 2, 'Sim'),
('Carlos Mendes', 'carlos@instituicao.com', 'Técnico de Suporte', 1, 'Sim'),
('Fernanda Lima', 'fernanda@instituicao.com', 'Analista de Faturamento', 4, 'Sim'),
('Juliana Rocha', 'juliana@instituicao.com', 'Analista de RH', 5, 'Sim');

INSERT INTO tipo_treinamento (nome, descricao, ativo) VALUES
('Integração', 'Treinamento voltado para novos colaboradores.', 'Sim'),
('Segurança da Informação', 'Treinamento sobre proteção de dados e uso seguro dos sistemas.', 'Sim'),
('Atendimento ao Cliente', 'Capacitação para melhoria no atendimento ao público.', 'Sim'),
('Sistema Interno', 'Treinamento para utilização de sistemas internos da instituição.', 'Sim'),
('Normas e Procedimentos', 'Treinamento sobre regras e rotinas institucionais.', 'Sim');

INSERT INTO status_treinamento (nome, descricao) VALUES
('Planejado', 'Treinamento cadastrado, mas ainda não iniciado.'),
('Em andamento', 'Treinamento em execução.'),
('Finalizado', 'Treinamento concluído.'),
('Cancelado', 'Treinamento cancelado.'),
('Adiado', 'Treinamento remarcado para uma nova data.');

INSERT INTO local_treinamento (nome, descricao, capacidade, ativo) VALUES
('Sala de Treinamento 1', 'Sala principal utilizada para capacitações internas.', 30, 'Sim'),
('Auditório', 'Ambiente utilizado para treinamentos com maior número de participantes.', 100, 'Sim'),
('Laboratório de Informática', 'Sala equipada com computadores para treinamentos práticos.', 20, 'Sim'),
('Sala de Reuniões', 'Ambiente para treinamentos menores e reuniões.', 15, 'Sim'),
('Ambiente Online', 'Treinamento realizado por videoconferência.', 200, 'Sim');

INSERT INTO treinamento (titulo, descricao, data_inicio, data_fim, carga_horaria_minutos, exige_presenca, instrutor, tipo_treinamento_id, responsavel_pessoa_id, status_treinamento_id, local_treinamento_id, ativo) VALUES
('Integração de Novos Colaboradores', 'Apresentação da instituição, normas internas e principais processos.', '2026-04-10 08:00:00', '2026-04-10 12:00:00', 240, 'Sim', 'Juliana Rocha', 1, 5, 3, 1, 'Sim'),
('Boas Práticas de Segurança da Informação', 'Orientações sobre senhas, phishing, proteção de dados e uso adequado dos sistemas.', '2026-04-12 14:00:00', '2026-04-12 16:00:00', 120, 'Sim', 'Arthur Silva', 2, 1, 3, 5, 'Sim'),
('Atendimento Humanizado', 'Capacitação voltada ao atendimento ao público interno e externo.', '2026-04-15 09:00:00', NULL, 180, 'Sim', 'Mariana Souza', 3, 5, 1, 2, 'Sim'),
('Uso do Sistema Interno', 'Treinamento prático para utilização do sistema institucional.', '2026-04-18 13:30:00', NULL, 240, 'Sim', 'Carlos Mendes', 4, 1, 1, 3, 'Sim'),
('Normas Internas e Conduta Profissional', 'Apresentação das normas, condutas e procedimentos internos.', '2026-04-20 08:30:00', NULL, 120, 'Sim', 'Juliana Rocha', 5, 5, 1, 1, 'Sim');

INSERT INTO status_participacao (nome, descricao) VALUES
('Inscrito', 'Participante inscrito no treinamento.'),
('Em andamento', 'Participante iniciou o treinamento.'),
('Participou', 'Participante concluiu o treinamento.'),
('Não participou', 'Participante não compareceu ao treinamento.'),
('Cancelado', 'Participação cancelada.');

INSERT INTO treinamento_participante (pessoa_id, treinamento_id, status_participacao_id, data_inscricao, progresso, ativo) VALUES
(1, 1, 3, '2026-04-01 08:00:00', 100.00, 'Sim'),
(2, 2, 3, '2026-04-02 09:00:00', 100.00, 'Sim'),
(3, 3, 1, '2026-04-03 10:00:00', 0.00, 'Sim'),
(4, 4, 2, '2026-04-04 11:00:00', 55.50, 'Sim'),
(5, 5, 1, '2026-04-05 13:00:00', 0.00, 'Sim');

INSERT INTO status_certificado (nome, descricao) VALUES
('Emitido', 'Certificado emitido com sucesso.'),
('Pendente', 'Certificado ainda não emitido.'),
('Cancelado', 'Certificado cancelado.'),
('Bloqueado', 'Certificado bloqueado por pendência.'),
('Reemitido', 'Certificado emitido novamente.');

INSERT INTO certificado_treinamento (treinamento_id, pessoa_id, status_certificado_id, data_emissao, carga_horaria_minutos, codigo_validacao) VALUES
(1, 1, 1, '2026-04-10 13:00:00', 240, 'CERT-2026-0001'),
(2, 2, 1, '2026-04-12 17:00:00', 120, 'CERT-2026-0002'),
(1, 3, 2, '2026-04-10 13:10:00', 240, 'CERT-2026-0003'),
(2, 4, 2, '2026-04-12 17:10:00', 120, 'CERT-2026-0004'),
(1, 5, 1, '2026-04-10 13:20:00', 240, 'CERT-2026-0005');