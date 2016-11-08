

<!-- toc -->

- [Introdução ao Node.js](#introdu%C3%A7%C3%A3o-ao-nodejs)
  * [O *Google V8*](#o-google-v8)
  * [*I/O* Não blocante](#io-n%C3%A3o-blocante)
  * [*Node.js* é *single thread*?](#nodejs-%C3%A9-single-thread)
- [Configurando o ambiente](#configurando-o-ambiente)
  * [O que é um transpiler](#o-que-%C3%A9-um-transpiler)
  * [Gerenciamento de projeto e dependências](#gerenciamento-de-projeto-e-depend%C3%AAncias)
- [Estrutura de diretórios e arquivos](#estrutura-de-diret%C3%B3rios-e-arquivos)
  * [O diretório root](#o-diret%C3%B3rio-root)
  * [O que fica no diretório root?](#o-que-fica-no-diret%C3%B3rio-root)
  * [Separação da execução e aplicação](#separa%C3%A7%C3%A3o-da-execu%C3%A7%C3%A3o-e-aplica%C3%A7%C3%A3o)
  * [Dentro do diretório *source*](#dentro-do-diret%C3%B3rio-source)
  * [Responsabilidades diferentes dentro de um mesmo source](#responsabilidades-diferentes-dentro-de-um-mesmo-source)
  * [*Server* e *client* no mesmo repositório](#server-e-client-no-mesmo-reposit%C3%B3rio)
  * [Separação por funcionalidade](#separa%C3%A7%C3%A3o-por-funcionalidade)
  * [Conversão de nomes](#convers%C3%A3o-de-nomes)
- [Iniciando o projeto](#iniciando-o-projeto)
  * [Configuração inicial](#configura%C3%A7%C3%A3o-inicial)
  * [Configurando suporte ao *Ecmascript* 6](#configurando-suporte-ao-ecmascript-6)
  * [Configurando o servidor web](#configurando-o-servidor-web)
  * [Express Middlewares](#express-middlewares)

<!-- tocstop -->

# Introdução ao Node.js

A primeira coisa que se deve entender quando se fala de *Node* é o que exatamente ele é. O *Node.js* não é nem uma linguagem e nem um *framework*, o termo mais apropriado seria um ambiente de runtime para *javascript* que roda em cima de uma *engine* conhecida como *Google v8*.
O *Node.js* nasceu de uma ideia do *Ryan Dahl* que queria acompanhar o progresso de *upload* de arquivos sem ter que fazer *pooling* no servidor. Em 2009 na *JSConf* Europeia ele mostra pela primeira vez o *Node.js* a comunidade, e introduz o *javascript server side* com *I/O* não blocante, ganhando assim o interesse da comunidade que começou a contribuir com o projeto desde a versão 0.x.

A primeira versão do *NPM (Node Package Manager)** foi lançada em 2011 permitindo que os desenvolvedores desenvolvessem e publicassem suas próprias bibliotecas e ferramentas. O *npm* é tão importante quanto o próprio *Node.js* sendo uma chave para o sucesso do mesmo.

Nessa época não era fácil usar o *Node*, com a fomentação em torno da tecnologia a frequência em que *breaking changes* aconteciam quase impossibilitava o desenvolvimento, até o lançamento da versão 0.8 que se manteve sem muitas *breaking changes*.
Mesmo com a frequência de atualizações a comunidade se manteve ativa, *frameworks* como *Express* e *Socket.IO* ja estavam em desenvolvimento desde 2010 e acompanharam lado a lado as versões da tecnologia.

O crescimento do *Node.js* foi muito rápido, mas isso não significa que ele não teve altos e baixos, como a saída do *Ryan Dahl* em 2012 e a separação dos *commiters* do *Node.js* em 2014. Infelizes com a administração da *Joyent* (empresa na qual *Ryan* trabalhara antes de sair do projeto) eles decidiram fazer um *fork* do projeto e chama-lo de *IO.js* com a intenção de prover releases mais rápidas e acompanhando as melhorias do *Google v8*.

Essa separação trouxe dor de cabeça a comunidade, que não sabia qual dos projetos deveria usar. Então a *Joyent* e outras grandes empresas como *IBM, Paypal e Microsoft* decidiram trabalhar juntas para ajudar a comunidade *Node.js* criando a *Node.js Foundation* que tem como missão uma administração transparente e que encoraje a comunidade a participar. Com isso foi feito *merge* dos projetos *Node.js* e *IO.js*. Com a fusão foi lançada a primeira versão estável do *Node.js*, a versão 4.0.

## O *Google V8*

O v8 é uma *engine* criada pela *Google* para ser usada no *browser chrome*. O *Google* decidiu torna la *open source* em 2008 e chama-la de *Chromium project*, possibilitando assim que a comunidade entendesse como o *javascript* é interpretado e compilado pela *engine* e também o entendimento da mesma.

O *javascript* é uma linguagem interpretada o que o deixa em desvantagem em comparação a linguagens compiladas pois cada linha de código precisa ser interpretada enquanto o código é executado. O V8 compila o código para linguagem de máquina além de otimizar drasticamente a execução usando heurísticas, permitindo que a execução seja feita em cima do código compilado e não interpretado.

## *I/O* Não blocante

## *Node.js* é *single thread*?


# Configurando o ambiente
A configuração do ambiente é a base para todo o projeto. Nela é configurado o *transpiler*, no nosso caso, o ***Babel.js***, as configurações do ***NPM***, a estrutura base de diretórios e etc.
Durante todo o livro a versão usada do *Node.js* será a 6.9.1 *LTS* (*long term support*). Para que seja possível usar as funcionalidades mais atuais do *javascript* será usado o *Ecmascript* na versão 6 *ES6* (*ES2015* ou *javascript* 2015), aqui iremos chamar de *ES6*. 

Como a versão do *Node.js* que usaremos não dá suporte inteiramente ao *ES6* será necessário usar um *transpiler* para que seja possível utilizar 100% das funcionalidades do *ES6* e executar o projeto na versão que estamos usando.

## O que é um transpiler
*Transpilers* também são conhecidos como compiladores *source-to-source* ou seja, de código para código. Usando um *transpiler* é possível escrever código utilizando as funcionalidade do *ES6* ou versões mais novas e transformar o código em um código suportado pela versão do *Node.js* que estaremos usando, no caso a 6.x. Um dos *transpilers* mais conhecidos do universo *javascript* é o [***Babel.js***](). 
Criado em 2015 por Sebastian McKenzie, o *Babel* permite utilizar as últimas funcionalidades do *javascript* e ainda assim executar o código em *browser engines* que ainda não suportam elas nativamente como no caso do *v8* (*engine* do *chrome* na qual o *Node.js* roda), pois ele traduz para uma forma suportada.

## Gerenciamento de projeto e dependências
Quase todas as linguagens possuem um gerenciador, tanto para automatizar tarefas, *build*, executar testes quanto gerenciar dependencias. O *javascript* possui uma gama de gerenciadores, como o [*Grunt*](), *Gulp* e *Brocoli* para gerenciar e automatizar tarefas, o *Bower* para gerenciar dependencias de projetos *front-end*. Para o ambiente *Node.js* é necessário um gerenciador que também permita a automatização de tarefas e customização de *scripts*.

Nesse cenário entra o [*npm*](http://) (*Node Package Manager*), criado por Isaac Z. Schlueter o *npm* foi adotado pelo *Node.js* e já vem embutido nele. O *npm registry* armazena mais de 400,000 pacotes públicos e privados de milhares de desenvolvedores e empresas possibilitando a divisão e contribuição de pacotes entre a comunidade *javascript*. 
 O cliente do *npm* (interface de linha de comando) permite utilizar o *npm* para criar projetos, automatizar tarefas e gerenciar dependencias.



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
# Iniciando o projeto

Para iniciar um projeto em *Node.js* a primeira coisa a fazer é inicializar o *npm* no diretório onde ficará a aplicação. Para fazer isso primeiro certifique de ter instalados o *Node.js* e o *npm* em seu computador, caso ainda não tenha eles instalados vá até o site do *Node.js* e faça o download https://nodejs.org/en/download/. Ele irá instalar junto também o *npm*.

## Configuração inicial
Crie um diretório onde ficará sua aplicação, após isso, dentro do diretório execute o seguinte comando:

```sh 
$ npm init
```

Semelhante ao *git* o *npm* inicializará um novo projeto nesse diretório, depois de executar o comando o *npm* realizará algumas perguntas (nem uma delas precisa ser respondida agora, podem ficar em branco, basta apertar enter) como:
1. **name**, referente ao nome do projeto.
2. **version**, referente a versão.
3. **description**, referente a descrição do projeto que está sendo criado.
4. **entry point**, arquivo que será o ponto de entrada caso o projeto seja importado por outro. 
5. **test command**, comando que executara os testes de aplicação. 
6. **git repository**, repositório git do projeto.
7. **keywords**, palavras chave para ajudar outros desenvolvedores a achar seu projeto no *npm*.
8. **author**, autor do projeto.
9. **license** referente a licença de uso do código.
Após isso um arquivo chamado **package.json** será criado e receberemos uma saída semelhante a essa:

```json
{
  "name": "node-book",
    "version": "1.0.0",
    "description": "",
    "main": "index.js",
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "author": "",
    "license": "ISC"
}
```

O **package.json** é responsavel por guardar as configurações npm do nosso projeto, nele ficarão nossos *scripts* para executar a aplicação e os testes.

## Configurando suporte ao *Ecmascript* 6 
Como vimos anteriormente o *Babel* sera responsavel por nos permitir usar as funcionalidades do *ES6*, para isso precisamos instalar os pacotes e configurar o nosso ambiente para suportar o *ES6* por padrão em nossa aplicação.
O primeiro passo é instalar os pacotes do *Babel*:

```sh
$ npm install --save-dev babel-cli
```

Após instalar o *Babel* é necessário instalar o *preset* que será usado, no nosso caso é o *ES6*:
```sh
$ npm install babel-preset-es2015 --save-dev
```

Note que sempre usamos *--save-dev* para instalar dependências referentes ao *Babel* pois ele não deve ser usado diretamente em produção, para produção iremos compilar o código, veremos isso mais adiante.

O último passo é informar para o *Babel* qual *preset* iremos usar, para isso basta criar um arquivo no diretório raiz da nossa aplicação chamado **.babelrc** com as seguintes configurações:

```json
{
  "presets": ["es2015"]
}
```

Feito isso a aplicação já esta suportando 100% o *ES6* e sera possivel usar todas as funcionalidades da versão.

## Configurando o servidor web
Como iremos desenvolver uma aplicação *web* precisaremos de um servidor que nos ajude a trabalhar com requisições *HTTP*, transporte de dados, rotas e etc. Dentre muitas opções no universo *Node.js* como o [*Sails.js*](), [*Hapi.js*]() e [*Koa.js*]() iremos optar pelo [*Express.js*]() por possuir um bom tempo de atividade, muito conteúdo na comunidade e ser mantido pela [*Node Foundation*]().

O *Express* é um *framework* para desenvolvimento *web* para *Node.js* inspirado no *Sinatra* desenvolvido para o *ruby on rails*. Criado por TJ Holowaychuk o *Express* foi adquirido pela [*StrongLoop*]() em 2014 e é administrado atualmente pela *Node.js Foundation*.
Iremos instalar dois modulos, o *express* e o *body-parser*:

```sh
$ npm install --save express body-parser
```

Quando uma requisição do tipo *POST* ou *PUT* é realizada seu corpo é transportado como texto, para que seja possível transportar dados como *JSON* (*JavaScript Object Notation*) por exemplo existe o modulo [*body-parser*]() que é um conjunto de *middlewares* para o *express* que analisa o corpo de uma requisição e transforma em algo definido, no nosso caso, em *JSON*.

Agora iremos criar um arquivo chamado **server.js** no diretório *root* e nele iremos fazer a configuração básica do *express*:
```javascript
import express from 'express';
import bodyParser from 'body-parser';

const app = express();
app.use(bodyParser.json());

app.get('/', (req, res) => res.send('Hello World!'));

app.listen(3000, () => {
    console.log('Example app listening on port 3000!');
    });
```
A primeira coisa feita no arquivo é a importação dos módulos *express* e *body-parser*, após isso uma nova instância do express é criada e associada a constante *app*. Para utilizar o *body-parser* é necessário configurar o *express* para usar o *middleware*, o *express* possui um método chamado *use* onde é possível passar *middlewares* como parâmetro, no código acima foi passado o **bodyParser.json()** responsavel por transformar o corpo das requisições em *JSON*.

A seguir é criado uma rota, os verbos *HTTP* como *GET*, *POST*, *PUT*, *DELETE* são funções no *express* que recebem como parâmetro um padrão de rota, no caso acima **"/"**, e uma função que será chamada quando a rota receber uma requisição. Os parametros **req** e **res** representam *request* (requisição) e *response* (resposta ) e serão injetados automaticamente pelo express quando a requisição for recebida.
Para finalizar, a função **listen** é chamada recebendo um número referente a porta na qual a aplicação ficará exposta, no nosso caso, 3000.

O último passo é configurar o *package.json* para iniciar nossa aplicação, para isso vamos adicionar um *script* de *start* dentro do objeto *scripts*:

```json
"scripts": {
  "start": "babel-node ./server.js",
    "test": "echo \"Error: no test specified\" && exit 1"
},
  ```

  Alterado o *package.json* basta executar o comando: 
  ```sh
  $ npm start
  ```

  Agora a aplicação estará disponível em **http://localhost:3000/**.
  Esse código está disponivel aqui: [STEP2]()

## Express Middlewares 
  *Middlewares* são funções que tem acesso aos objetos: requisição (*request*), resposta (*response*), e o próximo *middleware* que será chamado, normalmente nomeado como *next*.
  Essas funções são executadas antes da lógica da rota, dessa maneira é possível transformar os objetos de requisição e resposta, realizar validações, autenticações e até mesmo terminar a requisição antes que ela execute e lógica escrita na rota. 
  O exemplo a seguir mostra uma aplicação express simples com uma rota que devolve um *"Hello world"* quando chamada, nela sera adicionado um *middleware*.

  ```javascript
  const express = require('express');
  const app = express();

  app.get('/', function (req, res) {
      res.send('Hello World!');
      });

app.listen(3000);
```

*Middlewares* são apenas funções que recebem os parâmetros requisição (*req*), resposta (*res*) e próximo (*next*) executam alguma lógica e chamam o próximo *middleware*, caso não tenha, chamam a função da rota. No exemplo abaixo é criado um *middleware* que vai escrever *"LOGGED"* no terminal.

```javascript
const myLogger = function (req, res, next) {
  console.log('LOGGED');
  next();
};
```

Para que o express use essa função é necessário passar por parâmetro para a função use:

```javascript
const express = require('express');
const app = express();

const myLogger = function (req, res, next) {
  console.log('LOGGED');
  next();
};

app.use(myLogger);

app.get('/', function (req, res) {
    res.send('Hello World!');
    });

app.listen(3000);
```

Dessa maneira a cada requisição para qualquer rota o *middleware* sera invocado e ira escrever *"LOGGED"* no terminal.
*Middlewares* também podem ser invocados em uma rota específica:

```javascript
const express = require('express');
const app = express();

const myLogger = function (req, res, next) {
  console.log('LOGGED');
  next();
};

app.get('/', myLogger, function (req, res) {
    res.send('Hello World!');
    });

app.listen(3000);
```

Esse comportamento é muito útil e ajuda a não duplicar código, iremos ver mais sobre os *middlewares* ao decorrer do livro.

