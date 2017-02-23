# Configurando o *MongoDB* como banco de dados
 
 /todo

## Introdução ao MongoDB

/todo

## Configurando o banco de dados com *Mongoose*

Para integrar nossa aplicação com o *MongoDB* iremos utilizar o (*Mongoose*)[] que é *ODM (Object Document Mapper)*. O *Mongoose* irá abstrair o acesso ao banco de dados e ainda irá se responsabilizar por transformar os dados do banco em *Models*, o que irá facilitar a estruturação de nossa aplicação com o padrão *MVC*.

Para instalar o *Mongoose* basta executar o seguinte comando *npm*:

```sh
$ npm install mongoose --save
```

Após isso o *Mongoose* estará disponível para ser utilizado. O próximo passo será configurar a aplicação para conectar com o banco de dados, para isso crie um diretório chamado *config* dentro de *src* e dentro dele um arquivo chamado ***database.js*** que será responsável por toda configuração do banco de dados.
A estrutura de diretórios deve estar assim:

├── src
│   ├── app.js
│   ├── config
│   │   └── database.js
│   ├── controllers
│   │   └── products.js
│   └── routes
│       ├── index.js
│       └── products.js

A primeira coisa que deve ser feita no *database.js* é importar o módulo do *Mongoose* como no código abaixo:

```javascript
import mongoose from 'mongoose';
```

O próximo passo é informar qual biblioteca de *promises* está sendo usada, isso é uma necessidade da versão 4 do *Mongoose*. Como estamos usando o *Node.js* na versão 6 e ele já possui *promises* por padrão será necessário fazer somente o seguinte:

```javascript
mongoose.Promise = Promise;
```

Aqui é dito para o *Mongoose* utilizar a *promise* oficial do *Node.js*. Seguindo a configuração do banco de dados é necessário informar  a *url* onde está o *MongoDB*, no meu caso está no meu computador então será *"localhost"*  seguido do nome que daremos ao banco de dados:

```javascript
const mongodbUrl = process.env.MONGODB_URL || 'mongodb://localhost/test';
```

Note que primeiro é verificado se não existe uma variável de ambiente, caso não exista é usado o valor padrão que ira se referir ao *"localhost"** e ao banco de dados *"test"*. Dessa maneira poderemos utilizar o *MongoDB* tanto para testes quanto para rodar o banco da aplicação de verdade sem precisar alterar o código.

No passo seguinte iremos criar uma função para conectar no banco de dados, ela será responsável por inicializar a conexão com o banco de dados.

```javascript
const connect = () => mongoose.connect(mongodbUrl);
```

Aqui é criado uma função que retorna uma conexão com o *MongoDB*, esse retorno é uma *promise*, ou seja, somente quando a conexão for estabelecida a *promise* será resolvida, isso é importante pois precisamos garantir que nossa aplicação só vai estar disponível depois que o banco de dados estiver conectado e disponível para acesso.

O último passo é exportar o módulo de configuração do banco de dados:

```javascript
export default {
  connect
}
```

O código do *"database.js"* deve estar similar a este:

```javascript
import mongoose from 'mongoose';

mongoose.Promise = Promise;

const mongodbUrl = process.env.MONGODB_URL || 'mongodb://localhost/test';

const connect = () => mongoose.connect(mongodbUrl);

export default {
  connect
}
```

Pronto, o banco de dados está configurado, o próximo passo será integrar com a aplicação para que ela inicialize o banco sempre que for iniciada. 

## Integrando o *Mongoose* com a aplicação

O módulo responsável por inicializar a aplicação é o *app*, então será ele que irá garantir que o banco estará disponível para que a aplicação possa consumi-lo.
Vamos alterar o ***"app.js"*** para que ele integre com o banco de dados. Atualmente ele está assim:

```javascript
import express from 'express';
import bodyParser from 'body-parser';
import routes from './routes';

const app = express();
app.use(bodyParser.json());
app.use('/', routes);

export default app;
```

A primeira coisa a fazer é importar o módulo responsável pelo banco de dados, o *"database.js"** que fica dentro do diretório *config*. Os *imports* devem ficar assim:

```diff
```javascript
 import express from 'express';
 import bodyParser from 'body-parser';
 import routes from './routes';
+ import database from './config/database';
```
```




