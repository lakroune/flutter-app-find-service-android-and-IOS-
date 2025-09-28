
--   source C:\Users\Smail\Desktop\php_App\app.sql
#                 source C:\AppServ\www\app\app.sql



-- drop table evaluer;
-- drop table reserve;
-- drop table message;
-- drop table image;
-- drop table service;
-- drop table categorie;
-- drop table use;

 drop database app;
 create database app;
 	use app;
create table user( 
	idUser int not null auto_increment,
	nomUser varchar(100) not null,
	prenomUser varchar(100) not null,
	photo varchar(100)  ,
	ville varchar(100)  ,
	numTele varchar(10)  unique,
	email varchar(100) not null unique,
	password varchar(100) not null,
	dateCreation date not null,
	typeUser varchar(100) not null default 'client',
	etat varchar (100) not null default 'accepte',
	constraint PK_user primary key (idUser),
	constraint CK_typeUser check(typeUser in('client','artisan','admin') ),
	constraint CK_etatCompte check(etat in('en attente','accepte') )
);
 
create table categorie(
	idCategorie int not null auto_increment,
	nomCategorie varchar(100) not null ,
	constraint PK_catigorie primary key(idCategorie)
);

create table service(
	idService int not null auto_increment, 
	nomService varchar(100) not null,
	datePub date not null,
	prix int not null,
	idArtisan int not null,
	idCategorie int not null,
	etat varchar(20) default 'en attente',
	constraint CK_etatService check( etat in('en attente','accepte') ),
	constraint FK_propose foreign key(idArtisan) references user(idUser),
	constraint FK_apparitient foreign key(idCategorie) references categorie(idCategorie),
	constraint PK_service primary key(idService)
);

create table image(
	idImage int not null auto_increment,
	idService int not null,
	source varchar(100) not null,
	constraint FK_compose foreign key(idService) references service(idService),
	constraint PK_imgea primary key(idImage)
);

create table message(
	idMessage int not null auto_increment, 
	idUser1  int not null,
	idService int not null,
	idUser2  int not null,
	message varchar(100) not null,
	dateMessage date not null,
	constraint FK_envoyer1 foreign key(idUser1) references user(idUser) ,
	constraint FK_envoyer2 foreign key(idUser2) references user(idUser) ,
	constraint FK_mediat foreign key(idService) references service(idService) ,
	constraint PK_message primary key(idMessage)
);

create table reserve(
	idService int not null,
	idClient int not null,
	dateReservation date not null,
	prix decimal(10,2) not null,
	constraint FK_estReserver foreign key (idService ) references service (idService),
	constraint FK_reserve foreign key (idClient) references user (idUser)
);

create table evaluer(
	idService int not null,
	nombreEtoile int  not null,
	idClient int not null,
	comantaire varchar(150) not null,
	constraint CK_nombreEtoile check(nombreEtoile between 1 and 5),
	constraint Fk_evaluer foreign key(idClient) references user (idUser),
	constraint FK_estEvaluer foreign key (idService) references service (idService)
);

 create table enregistrie(
 	idService int not null,
 	idClient int not null,
 	dateEnregistrie date not null,
 	constraint FK_idSEV foreign key(idService) references service(idService),
 	constraint FK_idCLI foreign key(idClient) references user (idUser),
 	constraint PK_enrefistrie primary key(idService,idClient)
 	);