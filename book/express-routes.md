# Rotas com o express

O *express* possui um *middleware* nativo para lidar com rotas, o ***Router***.  O *Router* é responsável por administrar as rotas da aplicação e pode ser passado como parâmetro para o *app.use()*. Utilizando o *Router* é possível desacoplar as rotas, e também remover a necessidade de usar o *app* (instância do *express*) em outros lugares da aplicação.

## Separando as rotas

Vamos alterar nossa aplicação para separar as rodas do *app*. Para isso devemos criar um diretório chamado ***routes*** dentro de *src*. Os diretórios deverão ficar assim:

├── package.json
├── server.js
├── src
│   ├── app.js
│   └── routes

Dentro de *routes* criaremos um arquivo chamado *index.js*, ele será responsável por carregar todas as rotas da aplicação:

```javascript
import express from 'express';

const router = express.Router();

export default router;
```

No código acima importamos o *express* e acessamos o *Router* dentro dele e depois o exportamos.
Agora que temos um arquivo para administrar as rotas, vamos mover a lógica de administração das rotas que estão no *app.js* para o nosso *index.js*. Primeiro movemos a rota padrão. O arquivo de rotas deverá ficar assim:

```javascript
import express from 'express';

const router = express.Router();

router.get('/', (req, res) => res.send('Hello World!'));

export default router;
```

## Rotas por recurso

No código anterior não movemos a rota products, isso porque ela não ficará no *index.js*. Cada recurso da *api* terá seu próprio arquivo de rotas e o *index.js* ficará responsável por carregar todos eles.
Agora criaremos um arquivo para as rotas do recurso *products* da nossa *api*.

Para isso será necessário criar um arquivo chamado ***products.js*** dentro do diretório *routes*, ele terá o seguinte código:

```javascript
import express from 'express';

const router = express.Router();

export default router;
```

Agora podemos mover a rota *products* do *app.js* para o *products.js*. Ele deve ficar assim:

```javascript
import express from 'express';

const router = express.router();

router.get('/', (req, res) => res.send([{
  name: 'default product',
  description: 'product description',
  price: 100
}]));

export default router;
```

Note que agora o padrão da rota não é mais ***"/products"*** e somente **"/"** , isso é uma boa prática para separar recursos da *api*. Como nosso arquivo é *products.js* as rotas dentro dele serão referentes ao recurso *products* da *api*, por isso internamente não precisamos repetir esse prefixo. Deixaremos para o index carregar essa rota e dar o prefixo pra ela.
Vamos alterar o *index.js* para carregar a nossa nova rota, ele deve ficar assim:

```javascript
import express from 'express';
import productsRoute from './products';

const router = express.Router();

router.use('/products', productsRoute);
router.get('/', (req, res) => res.send('Hello World!'));

export default router;
```
Primeiro importamos a rota que foi criada anteriormente e damos o nome de ***productsRoute***, depois para carregar a rota chamamos a função *use* do *router* passando o prefixo da rota que será *"/products"** e o *productsRoute* que importamos.

Com as rotas configuradas o último passo é alterar o *app.js* para carregar nosso arquivo de rotas, ele deve ficar assim:

```javascript
import express from 'express';
import bodyParser from 'body-parser';
import routes from './routes';

const app = express();
app.use(bodyParser.json());
app.use('/', routes);

export default app;
```

As rotas que estavam no *app.js* foram movidas para seus respectivos arquivos, agora importamos apenas o *routes*. Como foi criado um *index.js* dentro de *routes* não é necessário especificar o arquivo, apenas importar o diretório */routes* e automaticamente o módulo do *Node.js* procurará primeiro por um arquivo *index.js* e o importara. Depois o *routes* é passado como parâmetro para a função *use* junto com o *"/"*, o que significa que toda requisição vai ser administrada pelo *routes*.

## Router paths 

Nos passos anteriores foram criadas algumas rotas que simbolizam caminhos na aplicação, combinando um padrão e um método *HTTP*, por exemplo uma requisição do tipo *get* na rota *"/"* irá retornar *"Hello World"*, ja em *"/products"* irá devolver um produto *fake*. Essa é a maneira de definir *endpoints* em *APIs* com o *express router*.

O caminho passado por parâmetro para o método *HTTP*, como por exemplo *router.get("/products")* é chamado de *path*. *Paths* (caminhos) podem ser *strings*, *patterns* ou expressões regulares. Caso precise testar rotas complexas o *express* possui um testador de rotas *online*, onde é possível colocar o caminho e verificar como ele será interpretado pelo *express router*.

## Executando os testes

Nesse momento nossos testes devem estar passando novamente, o que irá nos garantir que nossa refatoração foi concluída com sucesso.