import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['modal'];

  connect() {
    this.setupModal();
    this.setupEvent();
    this.showModal();
  }

  setupModal() {
    this.modal = new bootstrap.Modal(this.modalTarget, {
      backdrop: 'static',
    });
  }

  setupEvent() {
    const self = this;

    this.modalTarget.addEventListener('hide.bs.modal', () => {
      self.modalTarget.parentElement.removeAttribute('src');
      self.modalTarget.parentElement.removeAttribute('reloadable');
      self.modalTarget.remove();
    });

    document.addEventListener('turbo:before-visit', () => {
      self.hideModal();
    });
  }

  showModal() {
    this.modal.show();
  }

  hideModal(event) {
    event?.preventDefault();
    this.modal.hide();
  }
}
