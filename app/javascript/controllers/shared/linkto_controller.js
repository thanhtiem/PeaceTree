import { Turbo } from '@hotwired/turbo-rails';
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  navigate(event) {
    const mainTarget = event.currentTarget;
    const navigatePath = mainTarget.dataset?.href;
    const stopNavigateTarget = event.target.closest('.stop-navigate');

    if ((!stopNavigateTarget || !mainTarget.contains(stopNavigateTarget)) && navigatePath) {
      Turbo.visit(navigatePath);
    }
  }
}
