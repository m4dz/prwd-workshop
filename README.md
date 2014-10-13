PRWD Workshop
=============

Paris Web 2014, Ateliers.
[![Build Status](https://travis-ci.org/m4dz/prwd-workshop.svg?branch=master)](https://travis-ci.org/m4dz/prwd-workshop)


Objectif
--------

Un site en Responsive Web Design peut-il être performant ? On se pose souvent la question, cet atelier va tâcher d'y répondre de façon collaborative. Nous partons d'une base de travail commune, tirée du template [HTML5UP](http://html5up.net/) mis à disposition ici : http://html5up.net/prologue.

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

L'objectif de l'atelier est d'être participatif. Nous avons des idées d'optimisations, mais celles de tous sont bienvenues, au contraire. Nous utiliserons les [Issues](https://help.github.com/articles/creating-an-issue/) et [Pull-Requests](https://help.github.com/articles/using-pull-requests/) de GitHub pour que chacun des participants (nous-même également) puisse proposer ses améliorations.

**Si vous avez une idée mais si vous ne savez malheureusement pas comment la mettre en œuvre**, [créez une issue](https://github.com/m4dz/prwd-workshop/issues/new) pour la décrire le plus précisément possible, avec des liens vers des ressources externes si nécessaire/possible.

**Si vous savez mettre en œuvre votre idée**, c'est encore mieux, faites donc, et créez la Pull-Request associée. Chaque Pull-Request validée au cours de l'atelier se verra _mergée_ dans la branche `master`, ce qui provoquera son déploiement sur l'environnement de tests http://m4dz.github.io/prwd-workshop/ et procédera aux mesures de performances.

### Quelques règles à respecter

Même s'il faudrait dans l'absolu que ce soit fait, il n'est pas question dans le cadre de l'atelier Paris Web, en durée restreinte,  d'appliquer toutes les règles classiques d'optimisation de performances.

L'idée de cet atelier est d'aboutir à un ensemble de **recommandations d'optimisation des performances spécifiques aux sites responsives**, et du même coup une version performante du thème utilisé, qui restera distribué sous licence.

Sachant cela, quelques règles doivent être respectées :
- les propositions ne doivent pas altérer l'accessibilité du thème (mais elles peuvent l'améliorer)
- les propositions doivent respecter le principe d'amélioration progressive, toute présentation particulière CSS et tout fonctionnement JavaScript étant des enrichissements et non des nécessités

### Proposer une piste

Pour suggérer une amélioration technique, commencez par réaliser un [fork](https://help.github.com/articles/fork-a-repo/) du dépôt sur votre propre compte GitHub et clonez-le sur votre machine de développement. Procédez ensuite à l'installation des dépendances du projet :

```bash
$ cd <my_local_fork_path>
$ bundle install
$ npm install
```

### Isoler sa proposition

La structure de fichiers est définie telle qu'illustré ci-dessous. Pour isoler chaque proposition, on nommera sa piste, et ce nom générique servira à constituer l'arborescence.

Un exemple valant tous les bons discours, voilà comment ça fonctionne : la source originale issue du template HTML5UP - Prologue est logée derrière le préfixe `origin`.

```shell
-- build                      # La sortie compilée
`- src                        # Les sources
   |- css                     # Les CSS précompilées
   |  `- origin               # Les CSS liées à la version 'origin'
   |- js                      # Les sources JavaScript
   |  `- origin               # Les sources JS liées à la version 'origin'
   |- scss                    # Les sources SASS / Compass
   `- tpl                     # Les gabarits handlebars / assemble.io
      |- _includes            # Les partials utilisés dans les gabarits
      |  `- origin_*.hbs      # Les partials utilisés dans la version 'origin'
      |- _layouts             # Les layouts handlebars
      |  |- doc.hbs           # Le Layout de documentation
      |  `- origin.hbs        # Le layout utilisé dans la version 'origin'
      `- pages                # Les pages à compiler
         `- origin.hbs        # La page source de la version 'origin'
```

Pour développer votre proposition d'amélioration, nous vous conseillons de partir de la version `origin` et de ses _assets_ et d'y effectuer vos modifications. Par exemple, mettons que vous souhaitiez réaliser une amélioration concernant les breakpoints, en créant une version SASS des styles, et intervenant également sur les JS. Vous choisissez le nom de version `breakpoints` et votre arborescence devrait ressembler à :

```shell
-- build
`- src
   |- css
   |  `- origin
   |- js
   |  |- breakpoints            # Copie du répartoire js/origin dans laquelle 
   |  |                         # vous isolez vos modifications
   |  `- origin
   |- scss
   |  `- breakpoints            # Vos sources SASS liées à vos améliorations
   `- tpl
      |- _includes
      |  |- breakpoints_*.hbs   # Les partials utilisés dans votre version
      |  `- origin_*.hbs
      |- _layouts
      |  |- breakpoints.hbs     # Le layout de votre version, copié depuis
      |  |                      # origin.hbs
      |  |- doc.hbs
      |  `- origin.hbs
      `- pages
         |- breakpoints.hbs     # Votre page copiée depuis origin.hbs
         `- origin.hbs
```

De cette façon, nous obtiendrons dans la build finale un ensemble de pages, chacune correspondant à une évolution de version, et disposant de ses propres assets, ce qui nous permettra de réaliser des mesures comparées.


### Tester

Le _Gruntfile_ dispose d'une tâche de live capable de surveiller vos sources et de reconstruire un build de test local à chaque modification. Pour l'utiliser, lancez simplement `grunt live` depuis le répertoire du projet. Un serveur http local ouvre une connection sur http://localhost:8000 pour vous permettre de tester vos développements.

### Soumettre sa proposition

Pour soumettre votre proposition aux tests de déploiement continu, [soumettez une _Pull-Request_](https://help.github.com/articles/creating-a-pull-request/) sur la branche `master` du dépôt principal contenant votre piste validée et testée localement.

L'objectif étant de tester finement les améliorations, chaque PR ne devrait contenir que les modifications propres à tester une et une seule amélioration précise, pour isoler les comportements.


À vous de jouer, on vous attend !
