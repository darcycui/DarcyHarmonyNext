import { PrivateMessageResponse } from './PrivateMessageResponse';
import { Pageable } from './Pageable';
import { Sort } from './Sort';

export class PrivateMessageResponsePage {
  content: PrivateMessageResponse[] = [];
  empty: boolean = false;
  first: boolean = false;
  last: boolean = false;
  number: number = 0;
  numberOfElements: number = 0;
  pageable: Pageable = new Pageable();
  size: number = 0;
  sort: Sort = new Sort();
  totalElements: number = 0;
  totalPages: number = 0;
}
