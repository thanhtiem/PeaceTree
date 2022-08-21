import { Controller } from '@hotwired/stimulus';
import * as FilePond from 'filepond';
import FilePondPluginFilePoster from 'filepond-plugin-file-poster';
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';
import FilePondPluginFileValidateSize from 'filepond-plugin-file-validate-size';
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type';
import FilePondPluginImageExifOrientation from 'filepond-plugin-image-exif-orientation';

import 'filepond/dist/filepond.min.css';
import 'filepond-plugin-file-poster/dist/filepond-plugin-file-poster.css';
import 'filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css';

FilePond.registerPlugin(
  FilePondPluginFilePoster,
  FilePondPluginImagePreview,
  FilePondPluginImageExifOrientation,
  FilePondPluginFileValidateType,
  FilePondPluginFileValidateSize,
);

const MAX_FILE_SIZE = '5MB';

export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.setupFilePond();
  }

  setupFilePond() {
    if (!this.hasInputTarget) {
      return;
    }

    const options = this.buildInitOptions();
    FilePond.create(this.inputTarget, options);
  }

  buildInitOptions() {
    let options = {
      storeAsFile: true,
      maxFileSize: MAX_FILE_SIZE,
      labelIdle: 'Drag & drop here'
    };
    const { dataset } = this.inputTarget;

    if (dataset.styleLayout === 'avatar') {
      options = {
        ...options,
        imagePreviewHeight: 200,
        imageCropAspectRatio: '1:1',
        imageResizeTargetWidth: 200,
        imageResizeTargetHeight: 200,
        styleLoadIndicatorPosition: 'center bottom',
        styleButtonRemoveItemPosition: 'center bottom',
        stylePanelLayout: 'compact circle',
      };
    }

    if (dataset.files) {
      options = {
        ...options,
        files: JSON.parse(dataset.files),
      };
    }

    return options;
  }
}
