# *Controllers*

Os *controllers* serão responsáveis por receber as requisições das rotas, interagir com o *Model* quando necessário e retornar a resposta para o usuário.
No nosso código atual, as rotas estão com muita responsabilidade e dificeis de testar isoladamente pois dependemos do *express*, para arrumar isso precisamos adicionar os *controllers*. Iremos criar os *controllers* guiados por testes de unidade dessa maneira conseguiremos validar o comportamento separado do nosso sistema em si.

## Configurando os testes de unidade

Como vimos no capítulo de [testes de unidade](https://github.com/waldemarnt/building-testable-apis-with-nodejs/blob/master/book/build.md#testes-de-unidade-unit-tests), testes de unidade servem para testar pequenas partes do *software* isoladamente.

Para começar, crie um diretório chamado ***unit*** dentro do diretório *test* na raiz do projeto. Assim como fizemos nos testes de integração criaremos os arquivos de configuração para os testes.
Crie um arquivo chamado ***helpers.js*** dentro de *unit* com o seguinte código:

```javascript
import chai from 'chai';

global.expect = chai.expect;
```

Agora crie um arquivo para as configurações do *Mocha*, nomeie ele como ***mocha.opts***. Ele deve possuir o seguinte código:

```
--require test/unit/helpers.js
--reporter spec
--compilers js:babel-core/register
--slow 5000
```

A última etapa e configuração dos testes de unidade será a criação de um comando para executar os testes. Adicione o seguinte *script* no *package.json*:

```json
"test:unit": "NODE_ENV=test mocha --opts test/unit/mocha.opts test/unit/**/*_spec.js"
```

Para testar se o comando esta funcionando basta executar:

```sh
$ npm run test:unit
```

A saída do terminal deve informar que não conseguiu achar arquivos de teste:

```sh
Warning: Could not find any test files matching pattern: test/unit/**/*_spec.js
No test files found
```

Vamos criar nosso primeiro teste de unidade para o nosso futuro *controller* de produtos. A separação diretórios será semelhante a da aplicação com *controllers*, *models* e etc.

Crie um diretório chamado *controllers* dentro de *unit* e dentro dele um cenário de teste chamado *products_spec.js*. Agora execute os testes unitarios novamente, a saída deve ser a seguinte:

```sh
0 passing (2ms)
```

Ok, nenhum teste está passando pois ainda não criamos nenhum. 

## Testando o *controller* unitariamente

Vamos começar a escrever o teste. A primeira coisa será adicionar a descrição desse cenário de testes, como no código a seguir:

```javascript
describe('Controllers: Products', () => {

});
```

Esse cenário irá englobar todos os testes do *controller* de *products*. Agora vamos criar cenários para cada um dos métodos, adicione mais um cenário com o seguinte código:

```javascript
describe('Controllers: Products', () => {

    describe('get() products', () => {

    });

});
```

Criados os dois cenários de testes agora precisamos criar nosso primeiro caso de teste para o método *get*. Começaremos nosso caso de teste descrevendo o seu comportamento:

```javascript
describe('Controllers: Products', () => {

  describe('get() products', () => {
    it('should return a list of products', () => {

    });
  });

});
```
Segundo a descrição do nosso teste o método *get* deve retornar uma lista de produtos, esse é o comportamento que iremos garantir que está sendo contemplado. Começaremos iniciando um novo *controller* como no código a seguir:

```javascript
import ProductsController from '../../../src/controllers/products';

describe('Controllers: Products', () => {

  describe('get() products', () => {
    it('should return a list of products', () => {

      const productsController = new ProductsController();

    });
  });
});
```
Importamos o *ProductsController* do diretório onde ele deve ser criado e dentro do caso de teste inicializamos uma nova instância. Nesse momento se executarmos nossos testes de unidade devemos receber o seguinte erro:

```sh
Error: Cannot find module '../../../src/controllers/products'
    at Function.Module._resolveFilename (module.js:455:15)
    at Function.Module._load (module.js:403:25)
…
```
O a mensagem de erro fala que o módulo *products* não foi encontrado, como esperado. Vamos criar o nosso *controller* para que o teste passe.
Crie um diretório chamado ***controllers*** em *src* e dentro dele um *controller* para o recurso de *products* da *API* chamado ***products.js***. O código dele deve ser o seguinte:

```javascript
class ProductsController {

}

export default ProductsController;
```

Com o *controller* criado no diretório correto o nosso teste deve estar passando, execute novamente os testes unitários:

```sh
$ npm run test:unit
```

A saída do terminal deve ser a seguinte:

```sh
  Controllers: Products
    get() products
      ✓ should return a list of products


  1 passing (176ms)
```

Até aqui ainda não validamos o nosso comportamento esperado, apenas foi validado que o nosso *controller* existe. 
Agora precisamos garantir que o comportamento esperado no teste está sendo coberto, para isso precisamos testar se o método *get* chama a função de resposta do *express*.
Antes de começar esse passo precisamos instalar o *Sinon*, que é uma biblioteca que irá nos ajudar a trabalhar com *spies*, *stubs* e *mocks* os quais serão necessários para garantir o isolamento dos testes unitários.

## *Mocks, Stubs* e *Spies* com *Sinon.js*

Para instalar o *Sinon* basta executar o seguinte comando:

```sh
$ npm install --save-dev sinon
```

Após a instalação ele já estará disponível para ser utilizado em nossos testes.
Voltando ao teste, vamos importar o *Sinon* e também usar um *spy* para verificar se o método *get* do *controller* está realizando o comportamento esperado. O código do teste deve ficar assim:

```javascript
import ProductsController from '../../../src/controllers/products';
import sinon from 'sinon';

describe('Controllers: Products', () => {
  const defaultProduct = [{
    name: 'Default product',
    description: 'product description',
    price: 100
  }];

  describe('get() products', () => {
    it('should return a list of products', () => {
      const request = {};
      const response = {
        send: sinon.spy()
      };

      const productsController = new ProductsController();
      productsController.get(request, response);

      expect(response.send.called).to.be.true;
      expect(response.send.calledWith(defaultProduct)).to.be.true;
    });
  });
});
``` 
Muita coisa aconteceu nesse bloco de código, mas não se preocupe pois vamos passar por cada uma delas.
A primeira adição foi o *import* do *Sinon*, módulo que instalamos anteriormente.
Logo após a descrição do nosso cenário de teste principal foi adicionado uma constant chamada ***"defaultProduct"*** a qual armazena um *array* com um objeto com um produto com informações estáticas. Ele será útil para reaproveitarmos código nos casos de teste.
Já dentro do caso de teste foram adicionadas duas *constants* que são *request*, que é um objeto *fake* da requisição enviada pela rota do *express* a qual chamamos de *"req"* na aplicação, e *response* que é objeto um *fake* da resposta enviada pela rota do *express* que chamamos de *"res"* na aplicação.
Note que a propriedade *"send"* do objeto *response* recebe um *spy* do *Sinon*, como vimos antes no capítulo de *test doubles* os *spies* permitem gravar informações como: quantas vezes uma função foi chamada, quais parâmetros ela recebeu e etc. O que será perfeito em nosso caso de uso pois precisamos validar que a função send do objeto response está sendo chamada com os devidos parâmetros.

Até aqui já temos a configuração necessária para reproduzir o comportamento que esperamos. O próximo passo é chamar o método *get* do *controller* passando os objetos *request* e *response* que criamos. E o último passo é verificar se o método *get* está chamando a função *send* com o *defaultProduct* como parâmetro.
Para isso foram feitas duas asserções, a primeira verifica se a função *send* foi chamada, e a segunda se ela foi chamada com o *defaultProduct* como parâmetro.

Nosso teste está pronto, se executarmos os testes unitários devemos receber o seguinte erro:

```sh
  Controllers: Products
    get() products
      1) should return a list of products


  0 passing (156ms)
  1 failing

  1) Controllers: Products get() products should return a list of products:
     TypeError: productsController.get is not a function
      at Context.it (test/unit/controllers/products_spec.js:19:26)
```

O erro diz que *"productsController.get"* não é uma função, então vamos adicionar essa função ao *controller*. 
A função *get* deverá possuir a lógica que agora está na rota de produtos. Adicione o método *get* no *ProductsController*, o código deve ficar assim:

```javascript
class ProductsController {

  get(req, res) {
    return res.send([{
      name: 'Default product',
      description: 'product description',
      price: 100
    }])
  }
}

export default ProductsController;
```

O método *get* deve receber os objetos de requisição e resposta e enviar um *array* com um produto estático como resposta.

Agora basta executar os testes novamente, a saída do terminal deve ser a seguinte:

```sh

  Controllers: Products
    get() products
      ✓ should return a list of products


  1 passing (189ms)
```

## Integrando controllers e rotas

Nosso *controller* está feito, e estamos obtendo o comportamento esperado, mas até então não integramos com a aplicação. Para realizar essa integração basta alterar a rota de produtos para usar o *controller*. Edite o arquivo *"products.js"** em *"src/routes"*, removendo o bloco de código que foi movido para o *controller* e adicione a chamada para o método *get*, a rota de produtos deve ficar assim:

```javascript
import express from 'express';
import ProductsController from '../controllers/products';

const router = express.Router();
const productsController = new ProductsController();
router.get('/', (req, res) => productsController.get(req, res));

export default router;
```

Agora basta executar os testes de integração para garantir que o *controller* foi integrado corretamente com o resto da nossa aplicação. Execute:

```sh
$ npm run test:integration
```

A saída do terminal deve ser a seguinte:

```sh
  Routes: Products
    GET /products
      ✓ should return a list of products


  1 passing (251ms)
```

Os código desta etapa esta disponivel [aqui](https://github.com/waldemarnt/building-testable-apis-with-nodejs-code/tree/step5)
