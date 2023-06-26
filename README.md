
<h1>A solução consiste em uma arquitetura de duas camadas implantada na AWS em várias zonas de disponibilidade.</h1>h1>

A primeira camada consistirá em recursos de “computação”: um balanceador de carga, um grupo de dimensionamento automático e instâncias do EC2. Em seguida, a camada de “dados” será composta por uma instância RDS executando um servidor MySQL.

Aqui está o diagrama arquitetônico

![image](https://github.com/andreelidio/terraform-aws-alb-asg-efs-wordpress/assets/97263573/52c6c6bf-4882-4289-8fce-d5a187265c0d)


O ponto de entrada é um Elastic Load Balancer que balanceará e enviará o tráfego para uma série de instâncias do EC2. Nessas instâncias EC2, temos o WordPress instalado e, caso tenhamos uma situação de “alto tráfego”, podemos escalar rapidamente implantando novas máquinas. 

Implantei um grupo de dimensionamento automático que observa a carga da CPU dessas instâncias e adiciona ou encerra máquinas de acordo com a carga. Quando implantamos novas instâncias Ec2, usamos um modelo de inicialização que especifica o tipo EC2 e AMI (Amazon Machine Image). Há também um pequeno script de inicialização que será executado quando iniciar a máquina. 

Essas máquinas são recursos temporários. Quando o aplicativo estiver em alta demanda, teremos muitas instâncias, mas quando as coisas estiverem calmas, o sistema encerra o excesso de energia e podemos acabar com apenas um EC2. Devido a essa volatilidade, isso significa que não podemos armazenar dados persistentes no EC2. A solução para esse problema é implantar um Elastic File System(EFS) na EC2. 

Depois, vinculamos a pasta 'wp-content' do WordPress ao EFS. Essa ação garante que todos os arquivos de mídia, plug-ins e temas sejam armazenados fora da instância do EC2. Dessa forma, quando encerrarmos uma máquina EC2, não perderemos os plugins, temas ou mídias carregadas. E todos os EC2 implantados compartilharão esse EFS e terão acesso aos mesmos dados.

Seguindo o mesmo princípio, criamos uma instância RDS que executa o servidor MySQL. Novamente, a EC2 se conectará a esse banco de dados e o sistema não salvará os dados localmente. 
Como queremos que nosso aplicativo esteja altamente disponível, implantaremos nossos recursos em várias zonas de disponibilidade. Quando implantamos essa arquitetura, podemos acessar nosso novo site WordPress chamando o nome DNS do ELB. 

O monitoramento e observalidade ficará pelo AWS CloudWatch, irá monitorar as instâncias EC2 com o WordPress funcionando, existem várias formas de configuração e coleta de métricas disponíveis.
