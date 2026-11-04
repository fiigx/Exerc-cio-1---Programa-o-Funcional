# Consulta de popularidade de nomes

## Descrição

Nesta atividade individual, você implementará um programa em Haskell que permite ao usuário consultar a popularidade de nomes próprios a partir de dados fornecidos em arquivos. O programa lerá dois arquivos, um com nomes de garotos (`boynames.txt`) e outro com nomes de garotas (`girlnames.txt`), contendo os 1.000 nomes mais populares nos Estados Unidos para o ano de 2003, compilados pela Administração da Segurança Social.

Após carregar os dados, o programa entrará em um laço interativo, permitindo que o usuário digite um nome e veja sua classificação de popularidade e o número de registros, ou uma mensagem caso o nome não seja encontrado.

## Comportamento do programa

1.  No início, o programa deve ler e processar os arquivos `boynames.txt` e `girlnames.txt` para criar as tabelas de dados em memória.
2.  Em seguida, o programa entra em um laço interativo que se repete:
    a. Exibe o prompt `Nome: ` e aguarda a entrada do usuário.
    b. Lê uma linha de texto.
    c. Se a linha estiver em branco, o programa deve terminar.
    d. Se um nome for digitado, o programa deve pesquisar este nome em **ambas** as listas (garotos e garotas) e exibir o resultado para cada uma.
    e. O laço então recomeça do passo (a).

---

## Formato dos Arquivos de Entrada

O repositório template incluirá os arquivos `boynames.txt` e `girlnames.txt`. Cada linha desses arquivos contém um nome, seguido por um espaço e o número de registros daquele nome no ano. A popularidade (ranking) é determinada pela posição da linha no arquivo (a primeira linha é o 1º mais popular, a segunda é o 2º, e assim por diante).

**Exemplo de registros (`girlnames.txt`):**
```

Emily 25494
Emma 22532
Madison 19986
...

```

---

## Funções a Implementar

Recomenda-se fortemente que você divida seu programa nas seguintes funções, a serem implementadas em `src/Popularidade.hs`, conforme as especificações a seguir:

1.  **`tabela :: String -> [(Int, String, Int)]`**
    * Uma função **pura** que recebe o conteúdo de um dos arquivos como uma única `String` e o transforma em uma lista de tuplas. Cada tupla deve conter `(Ranking, Nome, Número de Registros)`.

2.  **`pesquisa :: String -> [(Int, String, Int)] -> String -> IO ()`**
    * Uma **ação de E/S** que recebe o tipo da lista ("garotos" ou "garotas"), a tabela de dados correspondente, e o nome a ser pesquisado. A ação deve imprimir o resultado formatado na tela (se o nome foi encontrado ou não).

3.  **`go :: [(Int, String, Int)] -> [(Int, String, Int)] -> IO ()`**
    * A **ação de E/S recursiva** principal que implementa o laço interativo. Ela recebe as duas tabelas de nomes (garotos e garotas), solicita a entrada do usuário e chama `pesquisa` para cada tabela.

4.  **`main :: IO ()`**
    * A **ação de E/S** que orquestra todo o programa. Ela deve:
        * Configurar o buffering de saída (`hSetBuffering stdout NoBuffering`).
        * Ler os dois arquivos (`readFile`).
        * Chamar a função `tabela` para processar o conteúdo de cada arquivo.
        * Iniciar o laço interativo chamando a ação `go` com as tabelas processadas.

---

## Exemplos de Execução

Seu programa deve replicar o comportamento dos exemplos abaixo:

**Exemplo 1:**
```shellsession
Nome: Justice
Justice classificado na posição 456 entre garotas com 655 registros
Justice classificado na posição 401 entre garotos com 653 registros
Nome: 
```

**Exemplo 2:**

```shellsession
Nome: Walter
Walter não encontrado entre garotas
Walter classificado na posição 356 entre garotos com 775 registros
Nome: 
```

---

## Requisitos e convenções

- A busca deve considerar exatamente o nome digitado, com diferenciação entre maiúsculas e minúsculas. Não é necessário normalizar espaços ou grafias.
- Os arquivos são fornecidos no repositório. Cada linha contém **dois campos**: nome e número de registros; a posição da linha, começando em 1, fornece o ranking.
- Uma linha de entrada vazia encerra a interação sem realizar outra consulta. A saída da consulta deve apresentar **garotas antes de garotos**, conforme os exemplos.
- O diretório de trabalho ao executar o programa deve ser a raiz do projeto, onde se encontram `boynames.txt` e `girlnames.txt`.
- A implementação deve preservar as assinaturas das quatro funções de `src/Popularidade.hs` e manter a interpretação dos dados em funções puras.
- Use casamento de padrões quando for razoável, especialmente ao percorrer listas e tratar casos base.

## Desenvolvimento e testes

No diretório raiz do projeto:

```bash
cabal update          # se necessário na primeira utilização
cabal build
cabal test
cabal run popularidade-nomes
```

Um ciclo de consulta termina quando o usuário pressiona Enter em uma linha vazia. Os testes Hspec fornecidos verificam parte dos requisitos; o professor pode utilizar casos adicionais na avaliação.

## Desenvolvimento, entrega e avaliação no GitHub

Nesta aula, **não será utilizado o Classroom 50**. Cada aluno criará um
**repositório próprio e privado** a partir do template público fornecido
pelo professor. O template original pertence à organização `UFOP-BCC222`,
mas os repositórios individuais serão criados nas contas dos alunos.

### 1. Criar seu repositório a partir do template

1. Acesse <https://github.com/UFOP-BCC222/a10.1-popularidade-nomes>.
2. Clique em **Use this template → Create a new repository**.
3. Escolha **Owner: sua conta pessoal**; nome: `a10.1-popularidade-nomes`.
4. Selecione **Private** e não marque **Include all branches**.
5. Clique em **Create repository**.

**Atenção:** não basta clonar o repositório da organização e executar
`git push`: a organização não concedeu aos alunos permissão para publicar
alterações nele. O clone deve ser feito **a partir de seu novo repositório
pessoal**, criado no passo anterior.

### 2. Clonar e trabalhar localmente

Copie a URL HTTPS do **seu próprio repositório** e execute:

```bash
git clone https://github.com/SEU-USUARIO/a10.1-popularidade-nomes.git
cd a10.1-popularidade-nomes
cabal build
cabal test --test-show-details=direct
cabal run popularidade-nomes
```

Se o Git solicitar autenticação, utilize Git Credential Manager ou
`gh auth login`, conforme o guia da disciplina. A senha de sua conta GitHub
não funciona como senha Git via HTTPS; nunca compartilhe tokens pessoais.

### 3. Enviar e conferir

```bash
git status
git add src/Popularidade.hs
git commit -m "Implementa consulta de popularidade de nomes"
git push origin main
```

Consulte a aba **Actions** do seu repositório e o resumo dos testes Hspec.
Corrija eventuais erros e faça novos `commit`/`push` quando necessário.
O projeto contém um workflow que executa os testes e informa uma pontuação
formativa por grupos; a nota oficial também poderá considerar revisão do
professor.

### 4. Dar acesso ao professor e identificar sua entrega

No **seu repositório privado**, abra **Settings → Collaborators → Add people**
e convide o usuário GitHub **`romildo`**. O convite deve ser aceito para
que o professor tenha acesso ao conteúdo e às execuções de Actions.

Envie a **URL do seu repositório pessoal** pelo canal indicado em aula,
junto com sua identificação acadêmica. Não envie somente o link do
template da organização.

**Prazo regular:** 4 de novembro de 2026, às **23h59** (horário de Brasília).
**Atrasos:** penalização linear de **10% da nota por dia de atraso**,
calculada posteriormente na planilha de notas. Registros de commit e
`push` serão utilizados na verificação do horário de entrega.

A avaliação automática é um auxílio ao desenvolvimento. Os alunos não
devem modificar os arquivos de testes e de configuração da avaliação.
