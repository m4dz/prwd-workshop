PRWD Workshop
=============

Paris Web 2014, Ateliers.


Objectif
--------

Un site en Responsive Web Design peut-il être performant ? On se pose souvent la question, cet atelier va tâcher d'y répondre de façon collaborative. Nous partons d'une base de travail commune, tirée du template HTML5UP mis à disposition ici : http://html5up.net/prologue.

L'objectif va être de procéder à des optimisations tant sur le plan du _responsive_ que des performances, puis de procéder à des mesures comparées pour déterminer si les pistes _bonnes pratiques / rwd / performances_ peuvent être efficacement utilisées.


Fonctionnement
--------------

L'environnement est défini par un ensemble de tâches [grunt](http://gruntjs.com/) qui vont gérer, notamment :
- le livereload lors du développement
- la compilation
- le déploiement continue sur un hébergement _gh-pages_
- les jeux de tests de mesure de performance

### Pré-requis

Pour utiliser le code présent, vous avez besoin d'un environnement disposant de Ruby, avec les droits pour installer des gems, de [Bundler](http://bundler.io/), de [Node.js](http://www.nodejs.org/) et son gestionnaire [NPM](https://www.npmjs.org/), et de l'utilitaire [CLI de grunt](http://gruntjs.com/getting-started#installing-the-cli).

Reportez-vous à votre documentation OS pour installer ces pré-requis.


Participation
-------------

L'objectif de l'atelier est d'être participatif. Nous avons des idées d'optimisations, mais celles de tous sont bienvenues, au contraire. Nous utiliserons les [Pull-Requests](https://help.github.com/articles/using-pull-requests/) de GitHub pour que chacun des participants (nous-même également) puisse proposer ses améliorations. Chaque Pull-Request validée au cours de l'atelier se verra _mergée_ dans la branche `master`, ce qui provoquera son déploiement sur l'environnement de tests http://m4dz.github.io/prwd-workshop/ et procédera aux mesures de performances.

### Proposer une piste

Pour suggérer une amélioration technique, commencez par réaliser un [fork](https://help.github.com/articles/fork-a-repo/) du dépôt sur votre propre compte GitHub et clonez-le sur votre machine de développement. Procédez ensuite à l'installation des dépendances du projet :

```bash
$ cd <my_local_fork_path>
$ bundle install
$ npm install
```

### Isoler sa proposition

{ A documenter, des changements de process sont à venir dans la structure. }

### Tester

Le _Gruntfile_ dispose d'une tâche de live capable de surveiller vos sources et de reconstruire un build de test local à chaque modification. Pour l'utiliser, lancez simplement `grunt live` depuis le répertoire du projet. Un serveur http local ouvre une connection sur http://localhost:8000 pour vous permettre de tester vos développements.

### Soumettre sa proposition

Pour soumettre votre proposition aux tests de déploiement continu, [soumettez une _Pull-Request_](https://help.github.com/articles/creating-a-pull-request/) sur la branche `master` du dépôt principal contenant votre piste validée et testée localement.

L'objectif étant de tester finement les améliorations, chaque PR ne devrait contenir que les modifications propres à tester une et une seule amélioration précise, pour isoler les comportements.


À vous de jouer, on vous attend !
