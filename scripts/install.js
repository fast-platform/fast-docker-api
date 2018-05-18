'use strict';

const async = require('async');
const fs = require('fs-extra');
const _ = require('lodash');
const util = require('./src/util/util');
const debug = require('debug')('formio:error');
const path = require('path');
const config = require('config');
const process = require('process');

module.exports = function(formio, items, done) {
  // The project that was created.
  let project = {};

  let projectTemplate = process.env.PROJECT_TEMPLATE || 'default';

  let root = {
    email: process.env.ROOT_EMAIL || 'admin@example.com',
    password: process.env.ROOT_PASSWORD || 'admin.123'
  }

  // All the steps in the installation.
  const steps = {

    /**
     * Import the template.
     * @param done
     */
    importTemplate: function(done) {
      if (!items.import) {
        return done();
      }

      const projectJson = path.join(__dirname, 'templates', `project.${projectTemplate}.json`);

      if (!fs.existsSync(projectJson)) {
        util.log(projectJson);
        return done('Missing ${projectJson} file'.red);
      }

      let template = {};
      try {
        template = JSON.parse(fs.readFileSync(projectJson));
      }
      catch (err) {
        debug(err);
        return done(err);
      }

      // Get the form.io service.
      util.log('Importing template...'.green);
      const importer = require('./src/templates/import')({formio: formio});
      importer.template(template, function(err, template) {
        if (err) {
          return done(err);
        }

        project = template;
        done(null, template);
      });
    },

    /**
     * Create the root user object.
     *
     * @param done
     */
    createRootUser: function(done) {
      if (!items.user) {
        return done();
      }
      util.log('Creating defaut root user account...'.green);
      util.log('Encrypting password');
      formio.encrypt(root.password, function(err, hash) {
        if (err) {
          return done(err);
        }

        // Create the root user submission.
        util.log(`Creating root user account ${root.email}`);
        formio.resources.submission.model.create({
          form: project.resources.admin._id,
          data: {
            email: root.email,
            password: hash
          },
          roles: [
            project.roles.administrator._id
          ]
        }, function(err, item) {
          if (err) {
            return done(err);
          }

          done();
        });
      });
    }
  };

  util.log('Installing...');
  async.series([
    steps.importTemplate,
    steps.createRootUser
  ], function(err, result) {
    if (err) {
      util.log(err);
      return done(err);
    }

    util.log('Install successful!'.green);
    done();
  });
};