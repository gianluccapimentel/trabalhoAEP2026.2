# DER (Mermaid)

Fonte equivalente a `der.puml`. Usar se o PlantUML não estiver disponível para renderizar a imagem.

```mermaid
erDiagram
    BIBLIOTECA ||--o{ LIVRO : "acervo (composição)"
    PESSOA ||--o{ EMPRESTIMO : realiza
    LIVRO ||--o{ EMPRESTIMO : "é emprestado"
    LIVRO ||--|{ LIVRO_AUTOR : possui
    AUTOR ||--o{ LIVRO_AUTOR : assina

    BIBLIOTECA {
        int id PK
        varchar nome
    }
    PESSOA {
        int id PK
        varchar nome
        varchar cpf UK
        varchar email
        varchar telefone
        varchar tipo
    }
    LIVRO {
        int id PK
        int biblioteca_id FK
        varchar titulo
        varchar isbn
        int ano_publicacao
        boolean disponivel
    }
    AUTOR {
        int id PK
        varchar nome
    }
    LIVRO_AUTOR {
        int livro_id PK_FK
        int autor_id PK_FK
    }
    EMPRESTIMO {
        int id PK
        int pessoa_id FK
        int livro_id FK
        date data_emprestimo
        date data_prevista_devolucao
        date data_devolucao
        varchar status
    }
```

Cardinalidades mínimas: `BIBLIOTECA` pode existir sem livros (o `schema.sql` já
insere uma biblioteca vazia) e `AUTOR` pode ser cadastrado antes de qualquer
associação (RF06) — por isso `o{` nos dois casos. `LIVRO ||--|{ LIVRO_AUTOR`
representa RN10 (livro com ao menos um autor), que é regra de negócio validada
na camada `service`: o DDL não impõe cardinalidade mínima em tabela associativa.
