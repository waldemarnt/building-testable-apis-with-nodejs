# Introdução ao *Node.js*

A primeira coisa que se deve entender quando se fala de *Node.js* é o que exatamente ele é. *Node.js* não é uma linguagem de programação nem tampouco um *framework*. A definição mais apropriada seria um ambiente de *runtime* para *javascript* que roda em cima de uma *engine* conhecida como *Google v8*.
O *Node.js* nasceu de uma ideia do *Ryan Dahl* que buscava uma solução para o problema de acompanhar o progresso de *upload* de arquivos sem ter que fazer pooling no servidor. Em 2009 na *JSConf EU* ele apresenta o *Node.js* a comunidade, e introduz o *javascript server side* com *I/O* não bloqueante, ganhando assim o interesse da comunidade que começou a contribuir com o projeto desde a versão 0.x.

A primeira versão do *NPM* (*Node Package Manager*), gerenciador de pacotes oficial, foi lançada em 2011 permitindo aos desenvolvedores a criação e publicação de suas próprias bibliotecas e ferramentas. O *npm* é tão importante quanto o próprio *Node.js* sendo um fator chave para o sucesso do mesmo.

Nessa época não era fácil usar o *Node*, com a fomentação em torno da tecnologia a frequência em que *breaking changes* aconteciam quase impossibilitava o desenvolvimento. O cenário se estabilizou com o lançamento da versão 0.8, que se manteve com baixo número de *breaking changes*.
Mesmo com a frequência de atualizações a comunidade se manteve ativa, *frameworks* como *Express* e *Socker.IO* já estavam em desenvolvimento desde 2010 e acompanharam, lado a lado, as versões da tecnologia.

O crescimento do *Node.js* foi rápido e teve altos e baixos como a saída do *Ryan Dahl* em 2012 e a separação dos *commiters* do *Node.js* em 2014, infelizes com a administração da *Joyent* (empresa na qual Ryan trabalhava antes de sair do projeto) eles decidiram fazer um *fork* do projeto e chama-lo de *IO.js* com a intenção de prover releases mais rápidas e acompanhando as melhorias do *Google V8*.

Essa separação trouxe dor de cabeça a comunidade que não sabia qual dos projetos deveria usar. Então, a *Joyent* e outras grandes empresas como *IBM, Paypal e Microsoft* decidiram trabalhar juntas para ajudar a comunidade *Node.js* criando a [*Node.js Foundation*](https://nodejs.org/en/foundation/) que tem como missão uma administração transparente e o encorajamento da participação da comunidade. Com isso, os projetos *Node.js* e *IO.js* se uniram, e com a fusão foi lançada a primeira versão estável do *Node.js*, a versão 4.0.

## O *Google V8*

O *V8* é uma *engine* criada pela *Google* para ser usada no *browser chrome*. Em 2008 a *Google*  tornou o *V8 open source* e passou a chamá-lo de *Chromium project*. Essa mudança possibilitou que a comunidade entendesse a *engine* em sí, além de compreender como o *javascript* é interpretado e compilado pela mesma.

O *javascript* é uma linguagem interpretada, o que o coloca em desvantagem quando comparado com linguagens compiladas, pois cada linha de código precisa ser interpretada enquanto o código é executado. O *V8* compila o código para linguagem de máquina, além de otimizar drasticamente a execução usando heurísticas, permitindo que a execução seja feita em cima do código compilado e não interpretado.  

## Entendendo o *Node.js* *single thread*

A primeira vista o modelo *single thread* parece não fazer sentido, qual seria a vantagem de limitar a execução da aplicação em somente uma *thread*? Linguagens como *Java*, *PHP* e *Ruby* seguem um modelo onde cada nova requisição roda em uma *thread* separada do sistema operacional. Esse modelo é eficiente mas tem um custo de recursos muito alto, nem sempre é necessário todo o recurso computacional aplicado para executar uma nova *thread*. 
O *Node.js* foi criado para solucionar esse problema, usar programação assíncrona e recursos compartilhados para tirar maior proveito de uma *thread*.

O cenário mais comum é um servidor *web* que recebe milhões de requisições por segundo; Se o servidor iniciar uma nova *thread* para cada requisição vai gerar um alto custo de recursos e cada vez mais será necessário adicionar novos servidores para suportar a demanda. O modelo assíncrono *single thread* consegue processar mais requisições concorrentes do que o exemplo anterior, com um número bem menor de recursos. 

Ser *single thread* não significa que o *Node.js* não usa *threads* internamente, para entender mais sobre essa parte devemos primeiro entender o conceito de *I/O* assíncrono não bloqueante.

## *I/O* assíncrono não bloqueante

Essa talvez seja a característica mais poderosa do *Node.js*, trabalhar de forma não bloqueante facilita a execução paralela e o aproveitamento de recursos. 
Para entender melhor, vamos pensar em um exemplo comum do dia a dia. Imagine que temos uma função que realiza várias ações, como por exemplo: uma operação matemática, ler um arquivo de disco, e transformar o resultado em uma *String*. Em linguagens bloqueantes como *PHP*, *Ruby* e etc, cada ação será executada apenas depois que a ação anterior for encerrada, no exemplo citado a ação de transformar a *String* terá que esperar uma ação de ler um arquivo de disco, que pode ser uma operação pesada, certo?
Vamos ver um exemplo de forma síncrona, ou seja, bloqueante:

```javascript
const fs = require('fs');
let fileContent;
const someMath = 1+1;


try {
  fileContent = fs.readFileSync('big-file.txt', 'utf-8');
  console.log('file has been read');
} catch (err) {
  console.log(err);
}


const text = `The sum is ${ someMath }`;
console.log(text);
```

Nesse exemplo, a última linha de código com o ***console.log*** terá que esperar a função ***readFileSync*** do module de *file system* executar, mesmo não possuindo ligação alguma com o resultado da leitura do arquivo. 

Esse é o problema que o *Node.js* se propôs a resolver, possibilitar que ações não dependentes entre sí sejam desbloqueadas. Para solucionar isso o *Node.js* depende de uma funcionalidade chamada *high order functions* que basicamente possibilitam  passar uma função por parâmetro para outra função, assim como uma variável, as funções passadas como parâmetro serão executadas posteriormente, como no exemplo a seguir:

```javascript
const fs = require('fs');

const someMatch = 1+1;

fs.readFile('big-file.txt', 'utf-8', function (err, content) {
    if (err) {
    return console.log(err)
    }
    console.log(content)
})

const text = `The response is ${ someMatch }`;
console.log(text);
```

No exemplo acima usamos a função ***readFile*** do módulo *file system*, assíncrona por padrão. Para que seja possível executar alguma ação quando a função terminar de ler o arquivo é necessário passar uma função por parâmetro, essa função será chamada automaticamente quando a função *readFile* finalizar a leitura.
Funções passadas por parâmetro para serem chamadas quando a ação é finalizada são chamadas de *callbacks*. No exemplo acima o *callback* recebe dois parâmetros injetados automaticamente pelo *readFile*: *err*, que em caso de erro na execução irá possibilitar  o tratamento do erro dentro do *callback*, e content que é a resposta da leitura do arquivo.

Para entender como o *Node.js* faz para ter sucesso com o modelo assíncrono é necessário entender também o *Event Loop*.

## *Event Loop*

O *Node.js* é guiado por eventos, termo também conhecido como *Event Driven*, esse conceito já é bastante aplicado em interações com interface de usuário. O *javascript* possui diversas *APIs* baseadas em eventos para interações com o *DOM* por exemplo, eventos como *onClick*, *onHide*, *onShow* são muito comuns no mundo *front-end* com *javascript*.

*Event driven* é um fluxo de controle determinado por eventos ou alterações de estado, a maioria das implementações possuem um ***core*** (central) que escuta todos os eventos e chama seus respectivos *callbacks* quando eles são lançados (ou tem seu estado alterado). Esse basicamente é o resumo do *Event Loop* do *Node.js*.

Separadamente a responsabilidade do *Event Loop* parece simples, mas quando nos aprofundamos para entender como o *Node.js* trabalha, notamos que o *Event Loop* é a peça chave para o sucesso do modelo *event driven*. Nos tópicos seguintes iremos entender cada um dos componentes que formam o ambiente do *Node.js*, como eles funcionam e como se conectam.

## *Call Stack*

A *stack* (pilha) é um conceito bem comum no mundo das linguagens de programação, frequentemente se ouve algo do tipo: "Estourou a pilha!". No *Node.js* e no *javascript* em geral esse conceito não se difere muito de outras linguagens, sempre que uma função é executada ela entra na *stack*, que executa somente uma coisa por vez, ou seja, o código posterior ao que está rodando precisa esperar a função atual terminar de executar para seguir adiante.
Vamos ver um exemplo:

```javascript
function generateBornDateFromAge(age) {
  return 2016 - age;
}

function generateUserDescription(name, surName, age) {
  const fullName = name + " " + surName;
  const bornDate = generateBornDateFromAge(age);

  return fullName + " is " + age + " old and was born in " + bornDate;
}

generateUserDescription("Waldemar", "Neto", 26);
```

Para quem já é familiarizado com *javascript* não ha nada especial acontecendo aqui. Basicamente, a função ***generateUserDescription*** é chamada recebendo nome, sobrenome e idade de um usuário e retorna uma sentença com as informações colhidas. A função *generateUserDescription* depende da função ***generateBornDateFromAge*** para calcular o ano que o usuário nasceu, essa dependência será perfeita para entendermos como a *stack* funciona.

![Stack 1](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/stack-1-1.svg)

No momento que a função *generateUserInformation* é invocada ela vai depender da função *generateBornDateFromAge* para descobrir o ano em que o usuário nasceu com base no parâmetro age (idade). Quando a função *generateBornDateFromAge* for invocada pela função *generateUserInformation* ela será adicionada a *stack* como no exemplo a seguir:

![Stack 2](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/stack-2-1.svg)

Conforme a função *generateUserInformation* vai sendo interpretada, os valores vão sendo atribuídos às respectivas variáveis dentro de seu escopo, como no exemplo do *fullName*. Para atribuir o valor a variável *bornDate* foi necessário invocar a função *generateBornDateFromAge* que quando invocada ela é imediatamente adicionada a *stack* até que a execução termine e a resposta seja retornada.
Após o retorno a *stack* ficará assim:

![Stack 3](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/stack-3-1.svg)

O último passo da função será concatenar as variáveis e criar uma frase, isso não irá adicionar mais nada a *stack*. Quando a função *generateUserInformation* terminar as demais linhas serão interpretadas, no nosso exemplo será o ***console.log*** imprimindo a variável *userInformation*.

![Stack 4](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/stack-4-1.svg)

Como a *stack* só executa uma tarefa por vez foi necessário esperar que a função anterior executasse e finalizasse, para que o *console.log* pudesse ser adicionado a *stack*.
Entendendo o funcionamento da *stack* podemos concluir que funções que precisam de muito tempo para execução irão ocupar mais tempo na *stack* e assim impedir a chamada das próximas linhas.

## *Multi threading*

Mas o *Node.js* não é *single thread*? Essa é a pergunta que os desenvolvedores *Node.js* provavelmente mais escutam. Na verdade quem é *single thread* é o *V8*, motor do *google* utilizado para rodar o *Node.js*. A *stack* que vimos no capitulo anterior faz parte do *V8*, ou seja, ela é *single thread*.
Para que seja possível executar tarefas assíncronas o *Node.js* conta com diversas outras *APIs*, algumas delas providas pelos próprios sistemas operacionais, como é o caso de eventos de disco, *sockets TCP* e *UDP*. Quem toma conta dessa parte de *I/O* assíncrono, de administrar múltiplas *threads* e enviar notificações é a ***libuv***.

A [*libuv*](https://github.com/libuv/libuv) é uma biblioteca *open source* multiplataforma escrita em *C*, criada inicialmente para o *Node.js* e hoje usada por diversos outros projetos como [*Julia*](http://julialang.org/) e [*Luvit*](https://luvit.io/).

O exemplo a seguir mostra uma função assíncrona sendo executada:

![Async 1](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/async-1-1.svg)

Nesse exemplo a função ***readFile*** do módulo de *file system* do *Node.js* é executada na *stack* e jogada para uma *thread*, a *stack* segue executando as próximas funções enquanto a função *readFile* está sendo administrada pela *libuv* em outra *thread*. Quando ela terminar o *callback* sera adicionado a uma fila chamada ***Task Queue*** para ser executado pela *stack* assim que ela estiver livre.

![Async 2](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/async-2-1.svg)

## *Task Queue*

Como vimos no capítulo anterior, algumas ações como *I/O* são enviadas para serem executadas em outra *thread* permitindo que o *V8* siga trabalhando e a *stack* siga executando as próximas funções. Essas funções enviadas para que sejam executadas em outra *thread* precisam de um *callback*. Um *callback* é basicamente uma função que será executada quando a função principal terminar.
Esses *callbacks* podem ter responsabilidades diversas, como por exemplo, chamar outras funções e executar alguma lógica.
Como o *V8* é *single thread* e só existe uma *stack*, os *callbacks* precisam esperar a sua vez de serem chamados. Enquanto esperam, os *callbacks* ficam em um lugar chamado *task queue* ou fila de tarefas. Sempre que a *thread* principal finalizar uma tarefa, o que significa que a *stack* estará vazia, uma nova tarefa é movida da *task queue* para a *stack* onde será executada.
Para entender melhor vamos ver a imagem abaixo:

![Async 4](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/async-4.svg)

Esse *loop*, conhecido como ***Event Loop***, é infinito e será responsável por chamar as próximas tarefas da *task queue* enquanto o *Node.js* estiver rodando.

## *Micro* e *Macro Tasks*

Até aqui vimos como funciona a *stack*, o *multithread* e também como são enfileirados os *callbacks* na *task queue*. Agora vamos conhecer os tipos de *tasks* (tarefas) que são enfileiradas na *task queue*, que podem ser *micro tasks* ou *macro tasks*.

### *Macro tasks*

Alguns exemplos conhecidos de *macro tasks* são: *setTimeout*, *I/O*, *setInterval*. Segundo a especificação do [*WHATWG*](https://html.spec.whatwg.org/multipage/webappapis.html#task-queue) somente uma *macro task* deve ser processada em um ciclo do *Event Loop*.

### *Micro tasks*

Alguns exemplos conhecidos de *micro tasks* são as *promises* e o *process.nextTick*. As *micro tasks* normalmente são tarefas que devem ser executadas rapidamente após alguma ação, ou realizar algo assíncrono sem a necessidade de inserir uma nova *task* na *task queue*.
A especificação do *WHATWG* diz que após o *Event Loop* processar a *macro task* da *task queue* todas as *micro tasks* disponíveis devem ser processadas e, caso elas chamem outras *micro tasks*, essas também devem ser resolvidas para que somente então ele chame a próxima *macro task*.

O exemplo abaixo demonstra como funciona esse fluxo:

![Async 5](https://cdn.rawgit.com/waldemarnt/building-testable-apis-with-nodejs/master/book/images/async-5.svg)
