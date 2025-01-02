

```markdown
# Gestion de Bibliothèque

Ce projet propose un système de gestion de bibliothèque utilisant SQL Server. Il couvre la création et la gestion d'une base de données pour les auteurs, livres, membres, et emprunts, avec des fonctionnalités avancées comme les procédures stockées, les triggers, et l'indexation.

---

## 🛠 Fonctionnalités

- **Gestion des auteurs, livres, membres et emprunts** :
  - Ajout, modification et suppression des enregistrements.
- **Procédures stockées** :
  - Ajout de membres.
  - Ajout d'emprunts.
  - Mise à jour de la date de retour des emprunts.
- **Création de vues** :
  - Vue des emprunts en cours avec les informations détaillées des livres et des membres.
- **Triggers SQL** :
  - Vérification des règles métier lors de l'ajout ou de la mise à jour des emprunts.
- **Indexation** :
  - Accélération des recherches sur les noms d'auteurs et les titres des livres.

---

## 🚀 Instructions d'Utilisation

### Étape 1 : Création de la Base de Données
```sql
CREATE DATABASE Bibliothèque;
```

### Étape 2 : Création des Tables
Les tables suivantes sont créées pour gérer les données :
- **Auteurs**
- **Livres**
- **Membres**
- **Emprunts**

Voir le code SQL dans ce dépôt pour plus de détails.

### Étape 3 : Insertion des Données
Ajoutez des auteurs, livres, membres et emprunts à l'aide des scripts d'insertion fournis.

### Étape 4 : Requêtes SQL
Exécutez des requêtes pour récupérer des informations sur les livres, les membres, et les emprunts.

---

## 💡 Fonctionnalités Avancées

1. **Vues** :
   - `VueEmpruntsActuels` : Affiche les emprunts en cours avec les informations associées.
   
2. **Triggers** :
   - `Trg_AfterInsert_Emprunts` : Vérifie si un livre est déjà emprunté avant d'ajouter un nouvel emprunt.
   - `Trg_BeforeUpdate_Emprunts` : Vérifie que la date de retour est supérieure à la date d'emprunt.

3. **Procédures Stockées** :
   - `AjouterMembre` : Ajoute un nouveau membre.
   - `AjouterEmprunt` : Ajoute un nouvel emprunt.
   - `RetournerLivre` : Met à jour la date de retour d'un emprunt.

4. **Indexation** :
   - Accélération des recherches par nom d'auteur et titre de livre.

---

## 📄 Requêtes Importantes

- **Liste des livres et leurs auteurs** :
  ```sql
  SELECT Livres.Titre, Auteurs.Nom, Auteurs.Prenom 
  FROM Livres 
  INNER JOIN Auteurs ON Livres.AuteurID = Auteurs.AuteurID;
  ```

- **Membres ayant emprunté un livre** :
  ```sql
  SELECT DISTINCT Nom, Prenom 
  FROM Membres 
  INNER JOIN Emprunts ON Membres.MembreID = Emprunts.MembreID;
  ```

- **Livres actuellement empruntés** :
  ```sql
  SELECT Titre, DateRetour 
  FROM Livres L
  JOIN Emprunts E ON L.LivreID = E.LivreID
  WHERE E.DateRetour IS NULL;
  ```

---

## 📌 À Propos
Ce projet met en œuvre des concepts avancés de SQL Server pour gérer efficacement une bibliothèque. Il est conçu pour les étudiants et développeurs souhaitant apprendre et expérimenter les bases de données relationnelles.

---

### 📝 Licence
Ce projet est sous licence MIT. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.
```

Ajoutez ce fichier README à votre dépôt pour donner une description claire et détaillée de votre projet. Si vous souhaitez des modifications supplémentaires, n'hésitez pas à demander ! 😊
