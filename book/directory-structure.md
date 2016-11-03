
# Estrutura de diretórios e arquivos
Um dos primeiros desafios quando começamos uma aplicação em *Node.js* é a estrutura do projeto. Uma das grandes conveniências do *Node*, por ser *javascript*, é a liberdade para estrutura, *design* de código, *patterns* e etc, mas isso também pode gerar confusão para os novos desenvolvedores.
A maioria dos projetos no *github* (https://github.com), por exemplo, possuem estruturas que diferem entre si, essa variação acontece pois cada desenvolvedor cria a estrutura da forma que se enquadrar melhor a sua necessidade.

Mesmo assim podemos aproveitar os padrões comuns entre esses projetos para estruturar nossa aplicação de maneira que atenda as nossas necessidades e também fique extensível, legível e facilmente integrável com ferramentas externas como *Travis*, *CodeClimate* e etc.
## O diretório root
O diretório *root* do projeto é o ponto de entrada, ou seja, a primeira impressão. No exemplo a seguir temos uma estrutura comum em aplicações usando o *framework* **Express.js**.

* controllers/
* middlewares/
* models/
* tests/
* .gitignore
* app.js
* package.json

Essa estrutura é legível e organizada, mas tende a ficar muito grande e misturar diretórios de código com diretórios de teste, *build* e etc, conforme o crescimento da aplicação. Um padrão comum em diversas linguagens é colocar o código da aplicação em um diretório *source* normalmente chamado *src*.

* src
    * controllers/
    * middlewares/
    * models/
* app.js
* tests/
* .gitignore
* server.js
* package.json

Dessa maneira o código da aplicação é isolado em um diretório deixando o *root* mais limpo e acabando com a mistura de diretórios de código com diretórios de testes e arquivos de configuração.

## O que fica no diretório root?
No exemplo acima movemos o código da aplicação para o diretório *src* mas ainda mantivemos o *tests*, o motivo disso é porque testes são executados ou por linha de comando ou por outras ferramentas. Inclusive os *test runners* como *mocha* e *karma* esperam que o diretório *tests* esteja no diretório principal. 
Outros diretórios comumente localizados no *root* são *scripts* de suporte ou *build*, exemplos, documentação e arquivos estáticos. No exemplo abaixo vamos incrementar nossa aplicação com mais alguns diretórios:
* env/
    * prod.env
    * dev.env
* public/
    * assets/
    * images/
    * css/
    * js/
* src
    * controllers/
    * middlewares/
    * models/
    * app.js
* tests/
* scripts/
    * deploy.sh
* .gitignore
* server.js
* package.json

O diretório *public* é responsável por guardar tudo aquilo que vai ser entregue para o usuário, usar ele no *root* facilita a criação de rotas de acesso e também movimentação dos assets caso necessário. Os diretórios *scripts* e *env* são relacionados a execução da aplicação e serão chamados por alguma linha de comando ou ferramenta externa, colocar eles em um diretório acessível facilita a usabilidade.

## Separação da execução e aplicação

No segundo passo, quando movemos o código para o diretório *src*, criamos um arquivo chamado **app.js** e mantemos o **server.js** no diretório *root*, dessa maneira deixamos o *server.js* com a responsabilidade de chamar o *app.js* e inicializar a aplicação. Assim isolamos a aplicação da execução e deixamos que ela seja executada por quem chamar, nesse caso o *server.js*, mas poderia ser um modulo como o *supertest* que vai fazer uma abstração *HTTP* para executar os testes e acessar as rotas.

## Dentro do diretório *source*
Agora que já entendemos o que fica fora do diretório *src* vamos ver como organizar ele baseado nas nossas necessidades.

* src/
    * controllers/
    * routes/
    * models/
    * middlewares/
    * app.js

Essa estrutura é bastante utilizada, ela é clara e separa as responsabilidades de cada componente, além de permitir o carregamento dinâmico.

## Responsabilidades diferentes dentro de um mesmo source 
As vezes quando começamos uma aplicação já sabemos o que será desacoplado e queremos dirigir nosso *design* para que no futuro seja possível separar e tornar parte do código um novo módulo. Outra necessidade comum é ter *APIs* específicas para diferentes tipos de clientes, como no exemplo a seguir:

* src/
    * mobile/
        * controllers/
        * routes/
        * models/
        * middlewares/
        * index.js
    * web
        * controllers/
        * routes/
        * models/
        * middlewares/
        * index.js
    * app.js

Esse cenário funciona bem mas pode dificultar o reuso de código entre os componentes, então, antes de usar, tenha certeza que seu caso de uso permite a separação dos clientes sem que um dependa do outro.

## *Server* e *client* no mesmo repositório
Muitas vezes temos o *backend* e *front-end* separados mas versionados juntos, no mesmo repositório, seja ele *git*, *mercurial*, ou qualquer outro controlador de versão. A estrutura mais comum que pude observar na comunidade para esse tipo de situação é separar o *server* e o *client* como no exemplo abaixo:

* client/
    * controllers/
    * models/
    * views/
* server/
    * controllers/
    * models/
    * routes/
* tests/
* config/
* package.json
* server.js
* client.js
* README.md

Essa estrutura é totalmente adaptável a necessidades. No exemplo acima, os testes de ambas aplicações estão no diretório *tests* no *root* assim se for adicionado o projeto em uma integração contínua ele vai executar a bateria de testes de ambas as aplicações. O **server.js** e o **client.js** são responsáveis por iniciar as respectivas aplicações, podemos ter um *npm start* no *package.json* que inicie os dois juntos.

## Separação por funcionalidade
Um padrão bem frequente é o que promove a separação por funcionalidade. Nele abstraimos os diretórios baseado nas funcionalidades e não nas responsabilidades, como no exemplo abaixo:

* src/
    * products/
        * products.controller.js
        * products.model.js
        * products.routes.js
    * orders/
        * orders.controller.js
        * orders.routes.js
    * app.js

Essa estrutura possui uma boa legibilidade e escalabilidade, mas por outro lado, pode crescer muito tornando o reuso de componentes limitado e dificultando o carregamento dinâmico de arquivos. 

## Conversão de nomes
Quando separamos os diretórios por suas responsabilidades pode não ser necessário deixar explícito a responsabilidade no nome do arquivo. Veja o exemplo abaixo:

* src/
    * controllers/
        * products.js
    * routes/ 
        * products.js


Como o nosso diretório é responsável por informar qual a responsabilidade dos arquivos que estão dentro dele, podemos nomear os arquivos sem adicionar o sufixo *“_”* + nome do diretório (por exemplo “_controller”). Além disso, o *javascript* permite nomear um módulo quando o importamos, permitindo que mesmo arquivos com o mesmo nome sejam facilmente distinguidos por quem está lendo o código, veja o exemplo:

```javascript
Import ProductsController from './src/controllers/products'; 
Import ProductsRoute from './src/routes/products'; 
```

Dessa maneira não adicionamos nenhuma informação desnecessária ao nomes dos arquivos e ainda mantemos a legibilidade do código.