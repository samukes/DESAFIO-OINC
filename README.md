Objetivo geral:
  * Demonstrar capacidade analítica, técnica e decisiva.

Descrição do projeto:
  * Um simples sistema onde se é possível cadastrar professores, alunos e agendar aulas.

Ponto crítico:
  * Imcompleto devido a complexidade do **Commanded**(incluindo testes unitarios para as operações do mesmo)
  * Este projeto foi criado de um boilerplate vazio usando os comandos do `mix phx.new`

O que falta do que foi pedido:
  * Testes unitários de casos de falha
  * Implentar fluxo Grapql para o schema Lesson
  * Implentar fluxo LiveView para o schema Lesson
  * Testes unitários para os casos Graphql e Liveview da Lesson

Setup do projeto:
  * `mix ecto.setup` para ambiente dev
  * `mix coveralls` para testes

O que poderia ser feito fora do escopo e com mais tempo:
  * Usar o Guardiam para autenticação
  * Implementar uma pipeline de CI(e talvez CD) no Git.
