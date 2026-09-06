import { Sort } from './Sort';

export class Pageable {
  offset: number = 0;
  pageNumber: number = 0;
  pageSize: number = 0;
  paged: boolean = false;
  sort: Sort = new Sort();
  unpaged: boolean = false;
}
