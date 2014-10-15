module.exports.register = function (Handlebars, options) {
  Handlebars.registerHelper('at', function(context, index, options) {
    if( options.fn ) { return options.fn(context[index]); }
    return context[index];
  });
};
