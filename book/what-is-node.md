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

## *Node.js* é *single thread*

A primeira vista o modelo *single thread* parece não fazer sentido, qual seria a vantagem de limitar a execução da aplicação em somente uma *thread*? Linguagens como *Java*, *PHP* e *Ruby* seguem um modelo onde cada nova requisição roda em uma *thread* separada do sistema operacional. Esse modelo é eficiente mas tem um custo de recursos muito alto, nem sempre é necessário todo o recurso computacional aplicado para executar uma nova *thread*. 
O *Node.js* foi criado para solucionar esse problema, usar programação assíncrona e recursos compartilhados para tirar maior proveito de uma *thread*.

O cenário mais comum é um servidor *web* que recebe milhões de requisições por segundo; Se o servidor iniciar uma nova *thread* para cada requisição isso vai ter um alto custo de recursos e cada vez mais será necessário adicionar novos servidores para suportar a demanda. O modelo assíncrono *single thread* consegue processar mais requisições concorrentes que o exemplo anterior com um número bem menor de recursos. 

O *Node.js* também possui comportamento nativo para rodar em *cluster*, ou seja, dividir as requisições em mais *threads*. A [*Cluster API*](https://nodejs.org/api/cluster.html) foi adicionada ao *Node.js* para permitir o escalonamento horizontal e também o uso de mais núcleos dos servidores, com ela é possível escalar uma aplicação facilmente. 

Ser *single thread* não significa que o *Node.js* não usa *threads* internamente, para entender mais sobre essa parte devemos primeiro entender o conceito de *I/O* assíncrono não blocante.

## *I/O* Não blocante



