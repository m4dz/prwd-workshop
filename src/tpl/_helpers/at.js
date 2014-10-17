module.exports.register = function (Handlebars, options) {
  Handlebars.registerHelper('at', function(context, datafile, branch, options) {
    var filename = datafile + '_' + branch;
    if( options.fn ) {
      return options.fn(context[filename]);
    }
    return context[filename];
  });
};
