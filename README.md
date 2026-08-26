# Sistema de Gerenciamento de Biblioteca

Aplicação acadêmica em Java para organizar o acervo e os empréstimos de uma biblioteca universitária. Esta 1ª entrega cobre planejamento e arquitetura; a 2ª entrega implementará o CRUD com PostgreSQL.

**Curso:** Engenharia de Software — AEP 4º semestre  
**Semestre:** 2026.2  
**ODS:** 4 — Educação de Qualidade  
**GitHub (público, a publicar):** `https://github.com/<usuario>/sistema-gerenciamento-biblioteca`

---

## 1. Nome do projeto

**Sistema de Gerenciamento de Biblioteca**

---

## 2. Descrição

O sistema centraliza cadastro de livros (um registro = um exemplar), pessoas (aluno, professor e bibliotecário), autores e empréstimos/devoluções. Prioriza organização, consistência dos dados, rastreabilidade da circulação e aplicação explícita de Programação Orientada a Objetos, com persistência real em banco relacional.

**Problema:** como organizar livros e empréstimos de forma simples, consistente e persistente, evitando controle manual e registros inconsistentes.

**Fora desta entrega:** não há CLI executável nem CRUD. Os pacotes Java existem vazios (`package-info.java`) para o repositório já nascer com a árvore da 2ª entrega.

---

## 3. ODS

**ODS 4 — Educação de Qualidade.**

Bibliotecas acadêmicas organizam o acesso a materiais de estudo e pesquisa. O software não resolve, sozinho, problemas educacionais amplos. A contribuição é operacional: organização do acervo, visibilidade da disponibilidade, controle de empréstimos, redução de erros administrativos e apoio ao uso dos materiais já existentes.

---

## 4. Integrantes

| Nome | RA |
|---|---|
| Gianlucca Barraco Pimentel | 26007478-2 |
| Nickolay Alexander Justini Dias | 26007083-2 |

---

## 5. Tecnologias

| Tecnologia | Uso nesta AEP |
|---|---|
| Java 21 | Linguagem; classe abstrata, herança, polimorfismo (`@Override`), composição |
| Maven | Build e dependências |
| PostgreSQL | Banco relacional |
| JDBC | Persistência (sem Hibernate/JPA) |
| CLI | Interface de linha de comando (2ª entrega) |
| JUnit 5 | Testes pontuais de regras de negócio (2ª entrega) |

**Não serão usados:** Spring Boot, Hibernate, GUI avançada, autenticação, APIs REST.

Camadas previstas: `model` / `repository` / `service` / `controller` / `database`.

---

## 6. Requisitos funcionais

| ID | Requisito |
|---|---|
| **RF01** | Cadastro de livros (título, ISBN, ano, quantidade de exemplares, disponibilidade). *Modelo:* cada linha de `Livro` é um exemplar; `disponivel` é booleano. |
| **RF02** | Consulta de livros e verificação de disponibilidade |
| **RF03** | Atualização de livros |
| **RF04** | Exclusão de livros quando não houver empréstimo ativo (RN08) |
| **RF05** | Cadastro de pessoas com tipo (aluno, professor, bibliotecário) |
| **RF06** | Cadastro de autores e associação aos livros |
| **RF07** | Registro de empréstimo (pessoa, livro, datas, status) |
| **RF08** | Registro de devolução e atualização da disponibilidade |
| **RF09** | Consulta de empréstimos ativos e finalizados |
| **RF10** | Impedir empréstimo de exemplar indisponível |

Documentação completa: [`docs/documentacao/AEP-1-entrega.md`](docs/documentacao/AEP-1-entrega.md).

---

## 7. Estrutura do projeto

```text
/
├── src/main/java/br/biblioteca/
│   ├── model/
│   ├── repository/
│   ├── service/
│   ├── controller/
│   └── database/
├── src/test/java/
├── docs/
│   ├── diagrama-classes/     # PlantUML + PNG/SVG
│   ├── der/                  # PlantUML + PNG/SVG
│   └── documentacao/         # 1ª entrega (Markdown; PDF se gerado)
├── database/
│   └── schema.sql
├── README.md
├── pom.xml
├── .gitignore
└── .env.example
```

Diagrama de classes: [`docs/diagrama-classes/`](docs/diagrama-classes/)  
DER: [`docs/der/`](docs/der/)

Modelo resumido:

- `Pessoa` (abstrata) → `Aluno`, `Professor`, `Bibliotecario` (STI em `pessoa.tipo`; subclasses só sobrescrevem `getTipo()`)
- Composição `Biblioteca 1 —— * Livro` (`biblioteca_id`)
- N:N `Livro`–`Autor` (`livro_autor`)
- `Emprestimo`: 1 pessoa + 1 livro; status `ATIVO` / `DEVOLVIDO`

---

## 8. Como configurar o PostgreSQL

Não use caminhos específicos de um computador. Credenciais **não** vão para o GitHub.

1. Instale o [PostgreSQL](https://www.postgresql.org/download/) e garanta que o serviço esteja em execução.
2. Crie o banco:

```sql
CREATE DATABASE biblioteca;
```

3. Aplique o schema:

```bash
psql -U postgres -d biblioteca -f database/schema.sql
```

4. Copie `.env.example` para `.env` e preencha:

```env
DB_URL=jdbc:postgresql://localhost:5432/biblioteca
DB_USER=postgres
DB_PASSWORD=sua_senha_local
```

O arquivo `.env` está no `.gitignore`. A 2ª entrega lerá essas variáveis na camada `database` (JDBC).

O `schema.sql` já insere uma linha em `biblioteca` (composição do acervo).

---

## 9. Como executar

A aplicação CLI **ainda não está implementada** (2ª entrega). Quando estiver, o fluxo previsto será:

1. Instalar **Java 21** (`java -version`).
2. Instalar **Apache Maven** (`mvn -version`).
3. Instalar **PostgreSQL**, criar o banco e executar `database/schema.sql`.
4. Configurar `.env` (ou exportar `DB_URL`, `DB_USER`, `DB_PASSWORD`).
5. Compilar e executar:

```bash
mvn compile
mvn exec:java -Dexec.mainClass=br.biblioteca.Main
```

Pacote:

```bash
mvn -q package
java -jar target/sistema-gerenciamento-biblioteca-1.0.0-SNAPSHOT.jar
```

Menu previsto:

```text
=================================
 SISTEMA DE BIBLIOTECA
=================================
1 - Gerenciar livros
2 - Gerenciar autores
3 - Gerenciar pessoas
4 - Realizar empréstimo
5 - Registrar devolução
6 - Consultar empréstimos
0 - Sair
```

---

## 10. Cronograma

Datas simuladas do semestre **2026.2** (bimestre 1 ≈ ago–out; bimestre 2 ≈ out–dez). Substituir pelas oficiais se necessário.

### Bimestre 1 — planejamento (1ª entrega)

| Etapa | Período | Atividade | Responsável |
|---|---|---|---|
| 1 | 03/08/2026 – 08/08/2026 | Definição do tema e ODS | Gianlucca + Nickolay |
| 2 | 10/08/2026 – 15/08/2026 | Levantamento do problema | Gianlucca |
| 3 | 10/08/2026 – 20/08/2026 | Levantamento de requisitos | Nickolay |
| 4 | 17/08/2026 – 22/08/2026 | Definição das regras de negócio | Gianlucca + Nickolay |
| 5 | 24/08/2026 – 05/09/2026 | Modelagem das classes | Gianlucca |
| 6 | 24/08/2026 – 05/09/2026 | Modelagem do banco / DER | Nickolay |
| 7 | 07/09/2026 – 13/09/2026 | Definição da arquitetura | Gianlucca + Nickolay |
| 8 | 07/09/2026 – 13/09/2026 | Criação do repositório | Nickolay |
| 9 | 14/09/2026 – 04/10/2026 | Organização da documentação | Gianlucca |
| 10 | 05/10/2026 – 16/10/2026 | Revisão final da 1ª entrega | Gianlucca + Nickolay |

### Bimestre 2 — implementação (2ª entrega)

| Etapa | Período | Atividade | Responsável |
|---|---|---|---|
| 1 | 19/10/2026 – 25/10/2026 | Implementação das entidades | Gianlucca |
| 2 | 19/10/2026 – 01/11/2026 | Implementação da persistência | Nickolay |
| 3 | 26/10/2026 – 08/11/2026 | Implementação dos repositories | Nickolay |
| 4 | 02/11/2026 – 15/11/2026 | Implementação dos services | Gianlucca |
| 5 | 09/11/2026 – 22/11/2026 | Implementação do CRUD | Gianlucca + Nickolay |
| 6 | 16/11/2026 – 29/11/2026 | Implementação da interface CLI | Gianlucca |
| 7 | 16/11/2026 – 29/11/2026 | Integração com PostgreSQL | Nickolay |
| 8 | 30/11/2026 – 06/12/2026 | Testes e correções | Gianlucca + Nickolay |
| 9 | 30/11/2026 – 13/12/2026 | Documentação | Gianlucca |
| 10 | 07/12/2026 – 18/12/2026 | Revisão final e entrega | Gianlucca + Nickolay |

---

## 11. Regras de negócio

| ID | Regra |
|---|---|
| **RN01** | Um livro precisa estar cadastrado antes de ser emprestado. |
| **RN02** | Uma pessoa precisa estar cadastrada antes de realizar um empréstimo. |
| **RN03** | Um livro indisponível não pode ser emprestado. |
| **RN04** | Um empréstimo deve possuir data de empréstimo e data prevista de devolução. |
| **RN05** | Ao registrar um empréstimo, atualizar a disponibilidade do livro. |
| **RN06** | Ao registrar uma devolução, atualizar a disponibilidade do livro. |
| **RN07** | Um empréstimo finalizado não pode ser devolvido novamente. |
| **RN08** | Um livro com empréstimo ativo não deve ser excluído. |
| **RN09** | Um empréstimo associa exatamente um usuário e um livro. |
| **RN10** | Um livro pode possuir um ou mais autores. |
| **RN11** | Uma pessoa deve possuir um tipo definido no sistema. |
| **RN12** | Validar dados obrigatórios antes de persistir. |

---

## 12. Exemplos de utilização (2ª entrega)

Fluxos previstos depois da implementação:

1. **Cadastrar autor e livro:** incluir autor; cadastrar exemplar (`titulo`, `isbn`, `anoPublicacao`, `disponivel = true`); associar autor via `livro_autor`.
2. **Cadastrar pessoa:** criar aluno, professor ou bibliotecário (`tipo` correspondente).
3. **Emprestar:** selecionar pessoa e livro disponível; gravar `Emprestimo` (`ATIVO`); marcar `disponivel = false`.
4. **Recusar indisponível:** tentativa de emprestar o mesmo exemplar deve falhar (RF10 / RN03).
5. **Devolver:** encerrar empréstimo (`DEVOLVIDO`, `dataDevolucao`); marcar `disponivel = true`.
6. **Excluir livro:** permitido apenas sem empréstimo `ATIVO` (RN08).
7. **Consultar:** listar acervo e filtrar empréstimos por status.

Exemplo de commits esperados na 2ª entrega (ambos os integrantes):

```text
feat: cria entidade Livro
feat: implementa LivroRepository
feat: adiciona cadastro de autores
feat: implementa regra de empréstimo
feat: adiciona conexão PostgreSQL
docs: atualiza README
fix: corrige validação de empréstimo
```
