# Desenvolvimento guiado por testes

Agora que vamos começar a desenvolver nossa aplicação, precisamos garantir que a responsabilidade, as possíveis rotas, as requisições e as respostas estão sendo atendidas; que estamos entregando o que prometemos e que está tudo funcionando. Para isso, vamos seguir um modelo conhecido como *TDD* (*Test Driven Development* ou Desenvolvimento Guiado por Testes).

## Test Driven Development - TDD
O *TDD* é um processo de desenvolvimento de *software* que visa o *feedback* rápido e garantia de que o comportamento da aplicação está cumprindo o que é requerido. Para isso, o processo funciona em ciclos pequenos e os requerimentos são escritos como casos de teste.

A prática do *TDD* aumentou depois que *Kent Beck* publicou o livro [*TDD - Test Driven Development*](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) e fomentou a discussão. Grandes figuras da comunidade ágil como *Martin Fowler* também influenciaram na adoção dessa prática publicando artigos, palestras e cases de sucesso.

## Os ciclos do *TDD*

Quando desenvolvemos guiados por testes, o teste acaba se tornando uma consequência do processo, ja que vai ser ele que vai determinar o comportamento esperado da implementação. Para que seja possível validar todas as etapas, o *TDD* se divide em ciclos que seguem um padrão conhecido como: ***Red***, ***Green***, ***Refactor***. 

### *Red*

Significa escrever o teste antes da funcionalidade e executá-lo, nesse momento como a funcionalidade ainda não foi implementada o teste deve quebrar, pois se não, há algo errado nele, essa fase também serve para verificar se não há erros na sintaxe e na semântica. 

### *Green*

Refere-se a etapa em que a funcionalidade é adicionada para que o teste passe. Nesse momento não é necessário ter a lógica definida, mas é importante atender os requerimentos do teste. Aqui podem ser deixados *to-dos*, dados estáticos, *fixmes*, ou seja, o suficiente para o teste passar.

### *Refactor*

É onde se aplica a lógica necessária e como o teste já foi validado nos passos anteriores ele garantirá que a funcionalidade está sendo implementada corretamente. Nesse momento devem ser removidos os dados estáticos além de coisas adicionadas somente para que o teste passasse, e ser feita a implementação real até que o teste volte a passar.
A imagem abaixo representa o ciclo do *TDD*:

![TDD cycles](./images/image-1.png)

## A piramide de testes

A pirâmide de testes é um conceito criado por *Mike Cohn*, escritor do livro [*Succeeding with Agile*](https://www.amazon.com/Succeeding-Agile-Software-Development-Using/dp/0321579364). O livro propõe que hajam mais testes de baixo nível, ou seja: testes de unidade, depois testes de integração e, no topo, testes que envolvem interface.

![Test pyramid](./images/image-2.png)

O autor observa que os testes de interface são custosos, para alguns testes é necessário inclusive licença de *softwares* que permitam a gravação dos passos e depois a execução do *playback* para ter a resposta do teste. Apesar de valioso, esse tipo de teste necessita de todo o ambiente para rodar e tende a demorar muito tempo.
O que *Mike* defende é ter a base do desenvolvimento com uma grande cobertura de testes de unidade; no segundo nível, garantir a integração entre os serviços e componentes com testes de integração, sem precisar envolver a interface do usuário. E no topo, possuir testes que envolvam o fluxo completo de interação com a *UI*, para validar todo o fluxo.

Vale lembrar que testes de unidade e integração podem ser feitos em qualquer parte da aplicação, tanto no lado do servidor quanto no lado do cliente, isso elimina a necessidade de ter testes complexos envolvendo todo o fluxo.

## Os tipos de testes

Atualmente contamos com uma variada gama de testes, sempre em crescimento de acordo com o surgimento de novas necessidades. Os mais comuns são os teste de unidade e integração, os quais iremos focar aqui.

### Testes de unidade (*Unit tests*)

Testes de unidade são a base da pirâmide de testes e possivelmente os mais comuns, ainda assim existem muitas pessoas que confundem o termo e as responsabilidades do mesmo. Segundo [*Martin Fowler*](http://martinfowler.com/bliki/UnitTest.html) , testes unitários são de baixo nível, com foco em pequenas partes do software e tendem a ser mais rapidamente executados quando comparados com outros testes, pois, testam partes isoladas. 

O primeiro ponto que deve ficar claro é: o que é uma unidade afinal? Esse conceito é divergente e pode variar de projeto, linguagem, time e paradigma de programação. Linguagens orientadas a objeto tendem a ter classes como uma unidade, já linguagens procedurais ou funcionais consideram normalmente funções como sendo uma unidade. Essa definição é algo muito relativo e depende do contexto e do acordo dos desenvolvedores envolvidos no processo. Nada impede que um grupo de classes relacionadas entre sí ou funções, sejam uma unidade.

No fundo, o que define uma unidade é o comportamento e a facilidade de ser isolada das suas dependências (dependências podem ser classes ou funções que tenham algum tipo de interação com a unidade).
Digamos que, por exemplo, decidimos que as nossas unidade serão as classes e estamos testando uma função da classe *Billing* que depende de uma função da classe *Orders*. A imagem abaixo mostra a dependência:

![unit tests 1](./images/image-3.png)

Para testar unitariamente é necessário isolar a classe *Billing* da sua dependência, a classe *Orders*, como na imagem a seguir:

![unit tests 2](./images/image-4.png)

Esse isolamento pode ser feito de diversas maneiras, por exemplo utilizando *mocks*, *stubs*, *spys* ou qualquer outra técnica de substituição de dependência e comportamento. O importante é que seja possível isolar a unidade e ter o comportamento esperado da dependência.

### Testes de integração (*Integration tests*)

Testes de integração servem para verificar se a comunicação entre os componentes de um sistema está funcionando conforme o esperado. Diferente dos testes de unidade, onde a unidade é isolada de duas dependências, no teste de integração deve ser testado o comportamento da interação entre as unidades. 
Não há um nível de granularidade específico, a integração pode ser testada em qualquer nível, seja a interação entre camadas, classes ou até mesmo serviços. 

No exemplo a seguir temos uma arquitetura comum de aplicações *Node.js* e desejamos testar a integração entre as rotas, *controllers*, *models* e banco de dados:

![integration tests 1](./images/image-5.png)

Nossa integração pode ser desde a rota até salvar no banco de dados (nesse caso, *MongoDB*), dessa maneira é possível validar todo o fluxo até o dado ser salvo no banco, como na imagem a seguir:

![integration tests 1](./images/image-6.png)

Esse teste é imprescindível mas custoso. Será necessário limpar o banco de dados a cada teste e criar os dados novamente, além de custar tempo e depender de um serviço externo como o *MongoDB*. Um grau de interação desse nível terá vários possíveis casos de teste, como por exemplo o usuário mandou um dado errado e deve receber um erro de validação, para esses tipos de cenário, às vezes é melhor diminuir a granularidade do teste para que seja possível ter mais casos de teste.
Para um caso onde o *controller* chama o *model* passando dados inválidos e a válidação deve emitir um erro, poderíamos testar a integração entre o *controller* e o *model*, como no exemplo a seguir:

![integration tests 2](./images/image-7.png)

Nesse exemplo todos os componentes do sistema são facilmente desacopláveis, podem haver casos onde o *model* depende diretamente do banco de dados e como queremos apenas testar a validação não precisamos inserir nada no banco, nesse caso é possível substituir o banco de dados ou qualquer outra dependência por um *mock* ou *stub* para reproduzir o comportamento de um banco de dados sem realmente chamar o banco.

![integration tests 6](./images/image-8.png)

### Teste de integração de contrato (*Integration contract tests*)

Testes de contrato ganharam muita força devido ao crescimento das *APIs* e dos micro serviços. Normalmente, quando testamos a nossa aplicação, mesmo com o teste de integração, tendemos a não usar os serviços externos e sim um substituto que devolve a resposta esperada. Isso por que serviços externos podem afetar no tempo de resposta da requisição, podem cair, aumentar o custo e isso pode afetar nossos testes.
Mas por outro lado, quando isolamos nossa aplicação dos outros serviços para testar ficamos sem garantia de que esses serviços não mudaram suas *APIs*, que a resposta esperada ainda é a mesma, para solucionar esses problemas existem os testes de contrato.

### A definição de um contrato

Sempre que consumimos um serviço externo dependemos de alguma parte dele ou de todos os dados que ele provém e o serviço se compromete a entregar esses dados. O exemplo abaixo mostra um teste de contrato entre a aplicação e um serviço externo, nele é verificado se o contrato entre os dois ainda se mantém o mesmo.

![contract tests 1](./images/image-9.png)

É importante notar que o contrato varia de acordo com a necessidade, nesse exemplo a nossa aplicação depende apenas dos campos *email* e *birthday* então o contrato formado entre eles verifica apenas isso. Se o *name* mudar ele não quebrará nossa aplicação nem o contrato que foi firmado.
Em testes de contrato o importante é o tipo e não o valor. No exemplo verificamos se o *email* ainda é *String* e se o campo *birthday* ainda é do tipo *Date*, dessa maneira garantimos que a nossa aplicação não vai quebrar. O exemplo a seguir mostra um contrato quebrado onde o campo *birthday* virou *born*, ou seja, o serviço externo mudou o nome do campo, nesse momento o contrato deve quebrar.

![contract tests 2](./images/image-10.png)

Testes de contrato possuem diversas extensões, o caso acima é chamado de *consumer contract* onde o consumidor verifica o contrato e, caso o teste falhe, notifica o *provider* (provedor) ou altera sua aplicação para o novo contrato. Também existe o *provider contracts* onde o próprio provedor testa se as alterações feitas irão quebrar os consumidores.

## *Test Doubles*

Testar código com *ajax*, *network*, *timeouts*, banco de dados e outras dependências que produzem efeitos colaterais é sempre complicado. Por exemplo, quando se usa *ajax*, ou qualquer outro tipo de *networking*, é necessário comunicar com um servidor que irá responder para a requisição; já com o banco de dados será necessário inicializar um serviço para tornar possível o teste da aplicação: limpar e criar tabelas para executar os testes e etc.

Quando as unidades que estão sendo testadas possuem dependências que produzem efeitos colaterais, como os exemplos acima, não temos garantia de que a unidade está sendo testada isoladamente. Isso abre espaço para que o teste quebre por motivos não vinculados a unidade em sí, como por exemplo o serviço de banco não estar disponível ou uma *API* externa retornar uma resposta diferente da esperada no teste.

Há alguns anos atrás Gerard Meszaros publicou  o livro *XUnit Test Patterns: Refactoring Test Code* e introduziu o termo *Test Double* (traduzido como “dublê de testes”) que nomeia as diferentes maneiras de substituir dependências. A seguir vamos conhecer os mais comuns test doubles e quais são suas características, prós e contras.

Para facilitar a explicação será utilizado o mesmo exemplo para os diferentes tipos de *test doubles*, também será usada uma biblioteca de suporte chamada [*Sinon.js*](http://sinonjs.org/) que possibilita a utilização de *stubs*, *mocks* e *spies*. 

A *controller* abaixo é uma classe que recebe um banco de dados como dependência no construtor. O método que iremos testar unitariamente dessa classe é o método ***"getAll"***, ele retorna uma consulta do banco de dados com uma lista de usuários.

```javascript
const Database = {
  findAll() {}
}

class UsersController {
  constructor(Database) {
    this.Database = Database;
  }

  getAll() {
    return this.Database.findAll('users');
  }
}
```

### *Fake*

Durante o teste, é frequente a necessidade de substituir uma dependência para que ela retorne algo específico, independente de como for chamada, com quais parâmetros, quantas vezes, a resposta sempre deve ser a mesma. Nesse momento a melhor escolha são os *Fakes*. *Fakes* podem ser classes, objetos ou funções que possuem uma resposta fixa independente da maneira que forem chamadas. O exemplo abaixo mostra como testar a classe *UsersController* usando um *fake*:

```javascript
describe('UsersController getAll()', () => {
  it('should return a list of users', () => {
    const expectedDatabaseResponse = [{
      id: 1,
      name: 'John Doe',
      email: 'john@mail.com'
    }];

    const fakeDatabase = {
      findAll() {
        return expectedDatabaseResponse;
      }
    }
    const usersController = new UsersController(fakeDatabase);
    const response = usersController.getAll();

    expect(response).to.be.eql(expectedDatabaseResponse);
  });
});
```
Nesse caso de teste não é necessária nenhuma biblioteca de suporte, tudo é feito apenas criando um objeto fake para substituir a dependência do banco de dados. O método ***"findAll"*** passa a ter uma resposta fixa, que é uma lista com um usuário.
Para validar o teste é necessário verificar se a resposta do método *"getAll"* do *controller* responde com uma lista igual a declarada no *"expectedDatabaseResponse"*.

Vantagens:

- Simples de escrever
- Não necessita de bibliotecas de suporte
- Desacoplado da dependencia original

Desvantagens:

- Não possibilita testar múltiplos casos
- Só é possível testar se a saída está como esperado, não é possível validar o comportamento interno da unidade

Quando usar *fakes*:

*Fakes* devem ser usados para testar dependências que não possuem muitos comportamentos.

### *Spy*

Como vimos anteriormente os *fakes* permitem substituir uma dependência por algo customizado mas não possibilitam saber, por exemplo, quantas vezes uma função foi chamada, quais parâmetros ela recebeu e etc. Para isso existem os *spies*, como o próprio nome já diz, eles gravam informações sobre o comportamento do que está sendo “espionado”.
No exemplo abaixo é adicionado um *spy* no método *"findAll"** do *Database* para verificar se ele está sendo chamado com os parâmetros corretos:

```javascript
describe('UsersController getAll()', () => {
  it('should database findAll with correct parameters', () => {
    const findAll = sinon.spy(Database, 'findAll');

    const usersController = new UsersController(Database);
    usersController.getAll();

    sinon.assert.calledWith(findAll, 'users');
    findAll.restore();
  });
});
```

Note que é adicionado um *spy* na função ***"findAll"*** do *Database*, dessa maneira o *Sinon* devolve uma referência a essa função e também adiciona alguns comportamentos a ela que possibilitam realizar checagens como *"sinon.assert.calledWith(findAll, 'users')"** onde é verificado se a função foi chamada com o parâmetro esperado.

Vantagens:

- Permite melhor assertividade no teste
- Permite verificar comportamentos internos
- Permite integração com dependências reais

Desvantagens:

- Não permitem alterar o comportamento de uma dependência
- Não é possível verificar múltiplos comportamentos ao mesmo tempo

Quando usar *spies*:

*Spies* podem ser usados sempre que for necessário ter assertividade de uma dependência real ou, como em nosso caso, em um *fake*. Para casos onde é necessário ter muitos comportamos é provável que *stubs* e *mocks* venham melhor a calhar.

### *Stub*

*Fakes* e *spies* são simples e substituem uma dependência real com facilidade, como visto anteriormente, porém, quando é necessário representar mais de um cenário para a mesma dependência eles podem não dar conta. Para esse cenário entram na jogada os *Stubs*. *Stubs* são *spies* que conseguem mudar o comportamento dependendo da maneira em que forem chamados, veja o exemplo abaixo:

```javascript
describe('UsersController getAll()', () => {
  it('should return a list of users', () => {
    const expectedDatabaseResponse = [{
      id: 1,
      name: 'John Doe',
      email: 'john@mail.com'
    }];

    const findAll = sinon.stub(Database, 'findAll');
    findAll.withArgs('users').returns(expectedDatabaseResponse);

    const usersController = new UsersController(Database);
    const response = usersController.getAll();

    sinon.assert.calledWith(findAll, 'users');
    expect(response).to.be.eql(expectedDatabaseResponse);
    findAll.restore();
  });
});
```

Quando usamos *stubs* podemos descrever o comportamento esperado, como nessa parte do código: 

```javascript
findAll.withArgs('users').returns(expectedDatabaseResponse);
```
Quando a função *"findAll"** for chamada com o parâmetro *"users"*, retorna a resposta padrão. 

Com *stubs* é possível ter vários comportamentos para a mesma função com base nos parâmetros que são passados, essa é uma das maiores diferenças entre *stubs* e *spies*.

Como dito anteriormente, *stubs* são *spies* que conseguem alterar o comportamento. É possível notar isso na asserção *"sinon.assert.calledWith(findAll, 'users')"** ela é a mesma asserção do *spy* anterior. Nesse teste são feitas duas asserções, apenas para mostrar a semelhança com *spies*, pois múltiplas asserções em um mesmo caso de teste é considerado uma má prática.

Vantagens:

- Comportamento isolado
- Diversos comportamentos para uma mesma função
- Bom para testar código assíncrono

Desvantagens:

- Assim como spies não é possível fazer múltiplas verificações de comportamento

Quando usar *stubs*:

*Stubs* são perfeitos para utilizar quando a unidade tem uma dependência complexa, que possui múltiplos comportamentos. Além de serem totalmente isolados os stubs também tem o comportamento de *spies* o que permite verificar os mais diferentes tipos de comportamento.


## O ambiente de testes em *javascript*

Diferente de muitas linguagens que contam com ferramentas de teste de forma nativa ou possuem algum *xUnit (JUnit, PHPUnit, etc)* no *javascript* temos todos os componentes das suites de testes separados, o que nos permite escolher a melhor combinação para a nossa necessidade (mas também pode criar confusão).
Em primeiro lugar precisamos conhecer os componentes que fazem parte de uma suíte de testes em *javascript*:

### *Test runners* 

*Test runners* são responsáveis por importar os arquivos de testes e executar os casos de teste. Eles esperam que cada caso de teste devolva *true* ou *false*. Alguns dos test runners mais conhecidos de *javascript* são o [*Mocha*](https://mochajs.org/) e o [*Karma*](https://karma-runner.github.io/1.0/index.html).

### Bibliotecas de *Assert*

Alguns *test runners* possuem bibliotecas de *assert* por padrão, mas é bem comum usar uma externa. Bibliotecas de *assert* verificam se o teste está cumprindo com o determinado fazendo a afirmação e respondendo com *true* ou *false* para o *runner*. Algumas das bibliotecas mais conhecidas são o [*chai*](http://chaijs.com/) e o [*assert*](https://nodejs.org/api/assert.html).

### Bibliotecas de suporte

Somente rodar os arquivos de teste e fazer o assert nem sempre basta, é necessário substituir dependências, subir servidores *fake*, alterar o *DOM* e várias outras coisas. Para isso existem as bibliotecas de suporte, elas se separam em diversas responsabilidades como por exemplo para fazer *mocks* e *spys* temos o [*SinonJS*](http://sinonjs.org/) e o [*TestDoubleJS*](http://sinonjs.org/). Já para emular servidores existe o [*supertest*](http://sinonjs.org/).
