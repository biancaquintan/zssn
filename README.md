# README


- Ruby version: *3.2.1*


- Run *'bundle install'*

- Run *'rails db:setup'*

<hr>

**FUNCIONALIDADES**

- **Cadastrar usuários na base:**

Um usuário é definido basicamente por seu nome, idade, sexo e última localização (latitude, longitude).
Ao ser criado, um usuário irá conter um inventário de itens que o mesmo detem (inicialmente vazio).

Os itens aceitos são: água, comida, medicamento e munição.

- **Atualizar localização de usuário**

Um usuário deve ser capaz de atualizar sua última localização, informando a nova latitude/longitude.

- **Marcar usuário como infectado:**

Em uma situação caótica como essa, é inevitável que um usuário do sistema venha a ser contaminado.
Nesse caso, o mesmo deve ser atualizado no sistema como infectado. Um usuário infectado não pode realizar escambo, não pode manipular seu inventário nem ser listado nos relatórios (para fins práticos, o mesmo está inativo).
Um usuário é considerado infectado quando ao menos 3 outros usuários distintos do sistema reportaram sua contaminação.
Ao ser infectado, todos os itens do inventário do usuário ficam inacessíveis.

- **Adicionar/Remover itens do inventário de um usuário**

Um usuário poderá adicionar/remover itens de seu inventário.

Os possíveis itens estão descritos na primeira opção acima;

- **Escambo de bens**

Usuários do sistema podem trocar bens entre si. Para isso, a tabela de equivalência abaixo será utilizada. 
Todos os escambos devem conter saldo final zero, ou seja, os dois usuários devem negociar a mesma quantidade de pontos.
Não é necessário realizar o registro do escambo, apenas transferir os itens entre os dois usuários.

Item/Pontos
Água    [4 pontos]
Comida	[3 pontos]
Remédio	[2 pontos]
Munição	[1 ponto]

- **Relatórios**
	
Para fins de consulta:	
	
	*Porcentagem de usuários infectados;
	*Porcentagem de usuários não-infectados;
	*Quantidade média de cada tipo de item por usuário (águas/usuário, comidas/usuário, etc);
	*Número de pontos perdidos por usuários infectados;
