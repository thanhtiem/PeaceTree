import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['alert'];

  connect() {
    const alert = bootstrap.Alert.getOrCreateInstance(this.alertTarget);

    setTimeout(() => {
      alert.close();
    }, 3000);
  }
}
