BAD_PARAMETERS_ERROR = { code: 0.1, message: 'Bad parameters' }.freeze

ACCESS_DENIED_ERROR = { code: 0.2, message: 'Access denied' }.freeze

INCORRECT_CREDENTIALS_ERROR = { code: 1.1, message: 'The introduced credentials are incorrect' }.freeze

ACCOUNT_BLOCKED_ERROR = { code: 1.2, message: 'The account is blocked' }.freeze

SESSION_EXPIRED_ERROR = { code: 2.1, message: 'The session has expired' }.freeze

READ_INVOICE_ERROR = { code: 3.1, message: 'The selected invoice could not be read' }.freeze

CREATE_INVOICE_ERROR = { code: 3.2, message: 'The invoice could not be created' }.freeze

UPDATE_INVOICE_ERROR = { code: 3.3, message: 'The invoice could not be updated' }.freeze

CREATE_CONTRACT_ERROR = { code: 4.1, message: 'The contract could not be created' }.freeze

UPDATE_CONTRACT_ERROR = { code: 4.2, message: 'The contract could not be updated' }.freeze

ATTACH_IMAGE_ERROR = { code: 4.3, message: 'The image could not be attached to the contract' }.freeze

READ_IMAGE_ERROR = { code: 4.4, message: 'The image attached to the contract could not be read' }.freeze