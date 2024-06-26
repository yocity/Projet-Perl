# Projet Perl


# Analyseur de logs Apache en Perl

Ce code permet d'analyser en temps réel les fichiers de logs Apache (access.log et error.log) afin de fournir des informations sur les requêtes réussies, les échecs de connexion et les messages d'erreur spécifiques, le tout présenté dans une interface graphique simplifiée.

## Fonctionnalités

- Surveille en temps réel les fichiers de logs d'accès et d'erreur d'Apache.
- Compte les occurrences d'événements tels que les requêtes réussies, les échecs de connexion et les messages d'erreur spécifiques.
- Affiche les résultats de l'analyse dans un format clair et concis.
- Utilise des expressions régulières pour extraire des informations spécifiques des entrées de journal.

## Utilisation

1. Assurez-vous d'avoir Perl installé sur votre système.
2. Copiez les fichiers `ProjetPerl.pl` et `README.md` dans le répertoire de votre choix.
3. Assurez-vous d'avoir les autorisations nécessaires pour lire les fichiers de logs Apache.
4. Exécutez le script Perl en utilisant la commande suivante :

    ```
    perl ProjetPerl.pl
    ```

5. Le code commencera à surveiller en temps réel les fichiers de logs Apache et affichera les résultats de l'analyse à mesure que de nouvelles lignes sont ajoutées aux fichiers de logs.

## Exigences

- Perl 5.x ou supérieur
- Modules Perl : `File::Tail`, `GD::Graph`, `GD::Graph::bars`, `GD::Graph::Data`

## Auteur

Ce projet a été développé par YOCOLI Konan Jean Epiphane, AHONZO Jean-Philippe, TOALO Bi Sidi Mohamed, N'GOUANDI Evrard.
