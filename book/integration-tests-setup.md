# Configurando testes de integração

Iremos testar de fora para dentro, ou seja, começaremos pelos testes de integração e depois testes de unidade.
Para começar vamos instalar as ferramentas de testes com o comando abaixo:

## Instalando Mocha Chai e Supertest

```sh
$ npm install --save-dev mocha chai supertest
```

Iremos instalar três módulos, que são:
*Mocha*: módulo que ira executar as suites de teste. 
*Chai*: módulo usado para fazer asserções.
*Supertest*: módulo usado para emular e abstrair requisições *http*.

## Separando execução de configuração

Após isso será necessário alterar a estrutura de diretórios da nossa aplicação atual, criando um diretório chamado ***src***, lugar onde ficará o código fonte. Dentro dele iremos criar um arquivo chamado ***app.js*** que terá a responsabilidade de iniciar o *express* e carregar os *middlewares*, ele ficará assim:

```javascript
import express from 'express';
import bodyParser from 'body-parser';

const app = express();
app.use(bodyParser.json());

app.get('/', (req, res) => res.send('Hello World!'));

export default app;
```

Basicamente copiamos o código do *server.js* e removemos a parte do *app.listen* a qual iniciava a aplicação e adicionamos o ***export default app*** para exportar o *app* como um módulo.
Agora precisamos alterar o *server.js* no diretório root para utilizar o *app.js*, vamos altera-lo para que ele fica dessa forma:

```javascript
import app from './src/app';
const port = 3000;

app.listen(port, () => {
  console.log(`app running on port ${port}`);
});
```

Note que agora separamos a responsabilidade de inicializar o *express*, carregar os *middlewares* da parte de iniciar a aplicação em si. Como nos testes a aplicação será inicializada pelo *supertest* e não pelo *express* como é feito no *server.js*, esse separação torna isso fácil.

## Configurando os testes

Agora que aplicação está pronta para ser testada, vamos configurar os testes. A primeira coisa a fazer é criar o diretório ***test*** no *root* e dentro dele o diretório onde ficarão os testes de integração, vamos chamar esse diretório de ***integration***. A estrutura de diretórios ficará assim:

```sh
├── package.json
├── server.js
├── src
│   └── app.js
└── test
    └── integration
```

Dentro de integration iremos criar os arquivos de configuração para os testes de integração. O primeiro será referente as configurações do *Mocha*, vamos criar um arquivo chamado ***mocha.opts*** dentro do diretório *integration* com o seguinte código:

```
--require test/integration/helpers.js
--reporter spec
--compilers js:babel-core/register
--slow 5000
```

O primeiro *require* será o arquivo referente as configurações de suporte para os testes, o qual criaremos a seguir. Na linha seguinte definimos qual será o *reporter*, nesse caso, o [*spec*](https://mochajs.org/#spec). *Reporters* definem o estilo da saida no teste no terminal.
Na terceira linha definimos os *compilers*, como iremos usar *Ecmascript6* também nos testes usaremos o *compiler* do *babel* no *Mocha*. E na última linha o *slow* referente a demora máxima que um caso de teste durar, como testes de integração tendem a depender de agentes externos como banco de dados e etc, é necessário ter um tempo maior de *slow* para eles.

O próximo arquivo que iremos criar nesse mesmo diretório é o ***helpers.js***. Ele tera o seguinte código:

```javascript
import supertest from 'supertest';
import chai from 'chai';
import app from '../../src/app.js';


global.app = app;
global.request = supertest(app);
global.expect = chai.expect;
```

O arquivo *helpers* é responsável por inicializar as configurações de testes que serão usadas em todos os testes de integração, removendo a necessidade de ter de realizar configurações em cada caso de teste.

Primeiro importamos os módulos necessários para executar os testes de integração que são o *supertest* e o *chai* e também a nossa aplicação *express* que chamamos de *app*. Depois definimos as globais usando **global**. Globais fazem parte do *Mocha*, tudo que for definido como global poderá ser acessado sem a necessidade de ser importado. No nosso arquivo *helpers* configuramos o *app* para ser global, ou seja, caso seja necessário usar ele em um caso de teste basta chama-lo diretamente.
Também definimos um global chamado ***request*** que é o *supertest* que recebe o nosso *express* por parâmetro. Lembram que falei da vantagem de separar a execução da aplicação da configuração do *express*? Agora o *express* pode ser executado por um emulador como o *supertest*.

## Criando o primeiro caso de teste

Com as configurações terminadas só nos resta criar nosso primeiro caso de teste. Vamos criar um diretório chamado ***routes*** dentro de *integration* e dentro dele criar o arquivo ***products_spec.js*** onde ficará o nosso teste referente as rotas do recurso *products* da nossa *API*.

A estrutura de diretórios deve estar assim:

```sh
├── package.json
├── server.js
├── src
│   └── app.js
└── test
    └── integration
        ├── helpers.js
        ├── mocha.opts
        └── routes
            └── products_spec.js
```

Agora precisamos escrever nosso caso de teste, vamos começar com o seguinte código no arquivo ***products_spec.js***:

```javascript
describe('Routes: Products', () => {
  
});
```

O ***describe*** é uma global do *Mocha* usada para descrever suites de testes que contém um ou mais casos de testes ou também outras suítes de testes. Como esse é o *describe* que irá englobar todos os testes desse arquivo seu texto descreve a responsabilidade geral da suite de testes, que é testar a rota *products*.
Agora vamos adicionar um produto padrão para os nossos testes:

```javascript
describe('Routes: Products', () => {
  const defaultProduct = {
    name: 'Default product',
    description: 'product description',
    price: 100
  };
});
```

Como a maioria dos testes precisará de um produto tanto para inserir quanto para verificar nas buscas, criamos uma constante chamada ***defaultProduct*** para ser reusada pelos casos de teste.
O próximo passo é descrever a nossa primeira suíte de testes:

```javascript
describe('Routes: Products', () => {
  const defaultProduct = {
    name: 'Default product',
    description: 'product description',
    price: 100
  };


  describe('GET /products', () => {
    it('should return a list of products', done => {


    });
  });
});
```

Adicionamos mais um *describe* para deixar claro que todas as suites de teste dentro dele fazem parte do método *http GET* na rota */products*. Isso facilita a legibilidade do teste e deixa a saída do terminal mais clara.
A função ***it*** também é uma global do *Mocha* e tem a responsabilidade de descrever um caso de teste.
Descrições de casos de teste seguem um padrão declarativo, como no exemplo acima: *"Isso deve retornar uma lista de produtos"*. Note que também é passado um parâmetro chamado *done* para o caso de teste, isso porque testes que executam funções assíncronas como requisições *http* precisam informar ao *Mocha* quando o teste finalizou, e fazem isso chamando a função *done*.
Veremos isso na implementação a seguir:

```javascript
describe('Routes: Products', () => {
  const defaultProduct = {
    name: 'Default product',
    description: 'product description',
    price: 100
  };


  describe('GET /products', () => {
    it('should return a list of products', done => {


      request
      .get('/products')
      .end((err, res) => {
        expect(res.body[0]).to.eql(defaultProduct);
        done(err);
      });
    });
  });
});
```

Na implementação do teste usamos o *supertest* que exportamos globalmente como ***request*** no *helpers.js* ele nos permite fazer uma requisição *http* para uma determinada rota e verificar a sua resposta.
Quando a requisição terminar a função *end* será chamada pelo *supertest*  recebendo erro , caso ocorra, e a resposta. Assim podemos fazer as asserções do nosso teste, no exemplo acima é verificado se o primeiro elemento da lista de produtos retornada é igual ao nosso *defaultProduct*.
O *expect* usado para fazer a asserção faz parte do *Chai* e foi exposto globalmente no *helpers.js*.

## Executando os testes

Escrito nosso teste, iremos executá-lo. Para automatizar a execução vamos adicionar a seguinte linha no ***package.json*** dentro de *scripts*:

```json
"test:integration": "NODE_ENV=test mocha --opts test/integration/mocha.opts test/integration/**/*_spec.js"
```

Nela é adicionado uma variável de ambiente como *test*, que além de boa prática também nos será útil logo, seguido das configurações do *Mocha*.

Para executar os testes agora basta executar o seguinte comando no terminal dentro do diretório *root* da aplicação:

```sh
$ npm run test:integration
```

A saida deve ser a seguinte:

```sh
Routes: Products
    GET /products
      1) should return a list of products




  0 passing (172ms)
  1 failing


  1) Routes: Products GET /products should return a list of products:
     Uncaught AssertionError: expected undefined to deeply equal { Object (name, description, ...) }

```

Ou seja, o teste está implementado corretamente, sem erros de sintaxe por exemplo, mas está falhando pois ainda não temos esse comportamento na aplicação, esse é o passo ***RED*** do *TDD* que vimos anteriormente.

O código dessa parte está disponivel [neste link](https://github.com/waldemarnt/building-testable-apis-with-nodejs-code/tree/step3).