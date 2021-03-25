

module.exports = {
  resolve: {
    extensions: ['.css'],
    alias: {
      jquery: 'jquery/src/jquery',
      Turbolinks: "turbolinks",
      Popper: ['popper.js', 'default'],
      'load-image': 'blueimp-load-image/js/load-image.js',
      'load-image-meta': 'blueimp-load-image/js/load-image-meta.js',
      'load-image-exif': 'blueimp-load-image/js/load-image-exif.js',
      'load-image-scale': 'blueimp-load-image/js/load-image-scale.js',
      'load-image-orientation': 'blueimp-load-image/js/load-image-orientation.js',

      'canvas-to-blob': 'blueimp-canvas-to-blob/js/canvas-to-blob.js',
      'jquery-ui/widget': 'blueimp-file-upload/js/vendor/jquery.ui.widget.js'

      // vue: 'vue/dist/vue.js',
      // React: 'react',
      // ReactDOM: 'react-dom',
      // vue_resource: 'vue-resource/dist/vue-resource'
    }
  }

}
