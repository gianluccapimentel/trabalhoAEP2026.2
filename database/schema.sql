-- ============================================================================
-- Sistema de Gerenciamento de Biblioteca — AEP 4º semestre (2026.2)
-- Schema PostgreSQL alinhado ao DER e ao diagrama de classes da 1ª entrega.
--
-- Decisões de modelagem:
--   * Livro = 1 exemplar (disponivel BOOLEAN). ISBN não é único:
--     vários exemplares do mesmo título podem coexistir.
--   * Herança STI: tabela única pessoa com coluna tipo.
--   * Composição Biblioteca 1—* Livro via biblioteca_id.
--   * N:N Livro–Autor via livro_autor.
--   * Emprestimo: exatamente 1 pessoa + 1 livro; status ATIVO | DEVOLVIDO.
--   * Histórico de circulação é preservado: nenhum empréstimo é apagado em
--     cascata. Ver a nota sobre RF04/RN08 na FK fk_emprestimo_livro.
-- ============================================================================

CREATE TABLE biblioteca (
    id   SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL
);

CREATE TABLE pessoa (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(150) NOT NULL,
    cpf       VARCHAR(14)  NOT NULL UNIQUE,
    email     VARCHAR(150),
    telefone  VARCHAR(20),
    tipo      VARCHAR(20)  NOT NULL,
    CONSTRAINT ck_pessoa_tipo CHECK (
        tipo IN ('ALUNO', 'PROFESSOR', 'BIBLIOTECARIO')
    )
);

CREATE TABLE livro (
    id              SERIAL PRIMARY KEY,
    biblioteca_id   INTEGER     NOT NULL,
    titulo          VARCHAR(255) NOT NULL,
    isbn            VARCHAR(20)  NOT NULL,
    ano_publicacao  INTEGER     NOT NULL,
    disponivel      BOOLEAN     NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_livro_biblioteca
        FOREIGN KEY (biblioteca_id) REFERENCES biblioteca (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_livro_ano CHECK (ano_publicacao > 0)
);

CREATE TABLE autor (
    id   SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL
);

CREATE TABLE livro_autor (
    livro_id INTEGER NOT NULL,
    autor_id INTEGER NOT NULL,
    PRIMARY KEY (livro_id, autor_id),
    CONSTRAINT fk_livro_autor_livro
        FOREIGN KEY (livro_id) REFERENCES livro (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_livro_autor_autor
        FOREIGN KEY (autor_id) REFERENCES autor (id)
        ON DELETE RESTRICT
);

CREATE TABLE emprestimo (
    id                        SERIAL PRIMARY KEY,
    pessoa_id                 INTEGER     NOT NULL,
    livro_id                  INTEGER     NOT NULL,
    data_emprestimo           DATE        NOT NULL,
    data_prevista_devolucao   DATE        NOT NULL,
    data_devolucao            DATE,
    status                    VARCHAR(20) NOT NULL,
    CONSTRAINT fk_emprestimo_pessoa
        FOREIGN KEY (pessoa_id) REFERENCES pessoa (id)
        ON DELETE RESTRICT,
    -- RF04 / RN08: o RESTRICT é mais forte que RN08 de propósito. RN08 proíbe
    -- excluir livro com empréstimo ATIVO; a FK também barra a exclusão quando
    -- só existem empréstimos DEVOLVIDOS, porque apagar o livro destruiria o
    -- histórico exigido por RF09. Na prática, RF04 só remove exemplar que
    -- nunca foi emprestado. A validação de RN08 continua na camada service.
    CONSTRAINT fk_emprestimo_livro
        FOREIGN KEY (livro_id) REFERENCES livro (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_emprestimo_status CHECK (
        status IN ('ATIVO', 'DEVOLVIDO')
    ),
    CONSTRAINT ck_emprestimo_datas CHECK (
        data_prevista_devolucao >= data_emprestimo
    ),
    CONSTRAINT ck_emprestimo_devolucao CHECK (
        data_devolucao IS NULL OR data_devolucao >= data_emprestimo
    ),
    -- RF08 / RN07: status e data_devolucao devem ser coerentes. Sem isto o
    -- banco aceita DEVOLVIDO sem data e ATIVO já com data de devolução.
    CONSTRAINT ck_emprestimo_status_devolucao CHECK (
        (status = 'ATIVO'     AND data_devolucao IS NULL)
     OR (status = 'DEVOLVIDO' AND data_devolucao IS NOT NULL)
    )
);

-- Um exemplar só pode ter um empréstimo ATIVO por vez (RF10 / RN03).
CREATE UNIQUE INDEX ux_emprestimo_livro_ativo
    ON emprestimo (livro_id)
    WHERE status = 'ATIVO';

CREATE INDEX ix_livro_biblioteca ON livro (biblioteca_id);
CREATE INDEX ix_emprestimo_pessoa ON emprestimo (pessoa_id);
CREATE INDEX ix_emprestimo_status ON emprestimo (status);

-- Composição: o acervo pertence a uma biblioteca. Uma linha inicial
-- permite cadastrar livros na 2ª entrega sem passo extra de setup.
INSERT INTO biblioteca (nome)
VALUES ('Biblioteca Acadêmica');
