const { environment } = require("@rails/webpacker");

environment.loaders.get("babel").use[0].options = {
  presets: [
    [
      "@babel/preset-env",
      {
        targets: {
          node: "current",
          browsers: [">0.25%", "not ie 11", "not op_mini all"],
        },
        useBuiltIns: "usage",
        corejs: 3,
      },
    ],
  ],
  plugins: ["@babel/plugin-syntax-dynamic-import", "@babel/plugin-proposal-object-rest-spread", ["@babel/plugin-transform-runtime", { regenerator: true }], "@babel/plugin-proposal-class-properties", "@babel/plugin-proposal-optional-chaining", "@babel/plugin-proposal-nullish-coalescing-operator"],
};

module.exports = environment;