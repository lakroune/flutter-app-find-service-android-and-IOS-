# 🛠️ Find Services

**Find Services** est une plateforme complète de mise en relation entre **clients** et **artisans/prestataires de services**.  
Elle permet aux utilisateurs de rechercher, proposer et gérer des services à proximité via une **application mobile Flutter** connectée à un **backend PHP/MySQL**.

---

## 🚀 Fonctionnalités principales

### 👥 Côté Utilisateur (Application mobile Flutter)
- Création et connexion de compte utilisateur ou artisan.  
- Consultation des services disponibles par catégorie.  
- Recherche avancée de services.  
- Sauvegarde de services favoris.  
- Messagerie intégrée entre clients et artisans.  
- Évaluation et avis sur les services.  

### 🧰 Côté Administrateur (Interface Web PHP)
- Tableau de bord d’administration.  
- Gestion des utilisateurs (ajout, suppression, modification).  
- Gestion des catégories et des services.  
- Validation ou refus des services proposés.  
- Supervision des évaluations et messages.  

---


---

## ⚙️ Technologies utilisées

### 🖥️ Backend
- **PHP 8+**
- **MySQL**
- **HTML / Bootstrap 5** (pour le panneau admin)

### 📱 Frontend (Mobile)
- **Flutter**
- **Dart**
- **HTTP Package** pour la communication API

---

## 🧩 Installation et configuration

### 1. Cloner le projet
```bash
git clone https://github.com/ton-utilisateur/find-services.git
```

### 2. Configurer le backend
1. Copier le dossier `backend` dans le répertoire de votre serveur local (ex: `htdocs` pour XAMPP).  
2. Importer le fichier `app.sql` dans **phpMyAdmin** pour créer la base de données.  
3. Vérifier et ajuster la configuration de connexion MySQL dans les fichiers PHP (`conn.php` ou équivalent).

### 3. Lancer le backend
```bash
http://localhost/find_services/app/
```

### 4. Lancer l’application Flutter
```bash
flutter pub get
flutter run
```

---

## 🔐 Sécurité et recommandations
- Protéger les fichiers PHP sensibles avec des vérifications de session.  
- Valider toutes les entrées utilisateurs (prévenir les injections SQL).  
- Masquer les erreurs PHP en production.  
- Configurer le CORS pour les requêtes entre Flutter et le backend.  

---

## 👨‍💻 Auteur
Projet développé par **Lakroune** — Développeur Full-Stack passionné par la création d’applications performantes et intuitives.

---
le 30-05-2022