// import 'core-js/stable'
// import 'regenerator-runtime/runtime'
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"



import $ from 'jquery'

// Turbolinks.start();
Rails.start()
Turbolinks.start()
ActiveStorage.start()

import Popper from "Popper"

import 'bootstrap'
// style
import "@fortawesome/fontawesome-free/css/all.css";

console.log('Hello World from common js')
