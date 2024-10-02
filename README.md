# BD_Systeme_Policier
Simulation d'une base de données SQL d'un Système policier

# Projet SQL : Base de données de surveillance policière

**Auteurs : Fabrice Senécal et Paul Labelle-Bilodeau**

Ce projet consiste à créer une base de données pour centraliser les informations de surveillance entre plusieurs postes de police. Chaque **événement** est répertorié avec une description, un code de nature spécifique, et les informations du policier responsable. La base de données permet également de documenter précisément le lieu où l'événement a eu lieu, en respectant les normes de toponymie québécoises.

## Caractéristiques principales :

- **Événements** : Chaque événement est identifié par un code unique (Ex. A101) lié à une catégorie d'activité (crime, vol, infraction, etc.).
- **Policiers** : Chaque policier est identifié par un matricule unique dans son poste de police. Sont enregistrés son nom, prénom, grade et service.
- **Lieux** : 
  - Les lieux incluent des **adresses**, **intersections**, et **bornes kilométriques**, toutes associées à une position GPS précise (latitude, longitude).
  - **Rues et autoroutes** : Les routes municipales sont associées aux villes, alors que les autoroutes possèdent des bornes kilométriques et ne sont pas liées directement aux villes.
  - Les rues sont décrites par leur type, article, nom, et secteur (Ex. *boulevard du Séminaire nord*).

Les relations entre les policiers, événements, lieux, et routes sont gérées via des clés étrangères, permettant une traçabilité précise des événements et de leur localisation.


